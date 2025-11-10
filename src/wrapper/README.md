# SERV RISC-V to AXI4 Wrapper

Wrapper module chuyển đổi SERV RISC-V processor từ Wishbone interface sang AXI4 Master interface.

## Cấu trúc

```
wrapper/
├── wb2axi_read.v      - Wishbone to AXI4 Read converter (cho Instruction Bus)
├── wb2axi_write.v     - Wishbone to AXI4 Write converter (cho Data Bus)
├── serv_axi_wrapper.v - Top-level wrapper kết nối SERV với AXI4
└── README.md          - Tài liệu này
```

## Kiến trúc

### SERV RISC-V Processor
- **Instruction Bus (ibus)**: Read-only Wishbone interface
- **Data Bus (dbus)**: Read-write Wishbone interface

### Wrapper Architecture

```
[SERV RISC-V Core]
       |
   +---+---+
   |       |
[ibus]  [dbus]
(Wishbone RO) (Wishbone RW)
   |       |
[wb2axi_] [wb2axi_]
[read]    [write]
   |       |
[AXI M0]  [AXI M1]
   |       |
   +---+---+
       |
[AXI Interconnect]
```

## Modules

### 1. `wb2axi_read.v`
Chuyển đổi Wishbone read-only interface sang AXI4 Read channels (AR + R).

**Wishbone Interface:**
- `wb_adr[31:0]` - Address
- `wb_cyc` - Cycle (valid request)
- `wb_rdt[31:0]` - Read data (output)
- `wb_ack` - Acknowledge (output)

**AXI4 Interface:**
- AR Channel: Read Address
- R Channel: Read Data

**FSM States:**
- `IDLE` - Chờ request
- `ADDR_REQ` - Gửi địa chỉ đọc
- `DATA_WAIT` - Chờ dữ liệu đọc

### 2. `wb2axi_write.v`
Chuyển đổi Wishbone read-write interface sang AXI4 Write channels (AW + W + B) và Read channels (AR + R).

**Wishbone Interface:**
- `wb_adr[31:0]` - Address
- `wb_dat[31:0]` - Write data
- `wb_sel[3:0]` - Byte select
- `wb_we` - Write enable
- `wb_cyc` - Cycle (valid request)
- `wb_rdt[31:0]` - Read data (output, cho read operations)
- `wb_ack` - Acknowledge (output)

**AXI4 Interface:**
- AW Channel: Write Address
- W Channel: Write Data
- B Channel: Write Response
- AR Channel: Read Address (cho read operations)
- R Channel: Read Data (cho read operations)

**FSM States:**
- `IDLE` - Chờ request
- `WRITE_ADDR` - Gửi địa chỉ ghi
- `WRITE_DATA` - Gửi dữ liệu ghi
- `WRITE_RESP` - Chờ response
- `READ_ADDR` - Gửi địa chỉ đọc
- `READ_DATA` - Chờ dữ liệu đọc

### 3. `serv_axi_wrapper.v`
Top-level wrapper kết nối SERV processor với AXI4.

**Ports:**
- `ACLK` - Clock (cùng clock cho SERV và AXI)
- `ARESETN` - Reset (active-low, AXI style)
- `i_timer_irq` - Timer interrupt (optional)
- `M0_AXI_*` - AXI4 Master Port 0 (Instruction Bus, Read-only)
- `M1_AXI_*` - AXI4 Master Port 1 (Data Bus, Read-write)

**Internal Connections:**
- SERV `o_ibus_*` → `wb2axi_read` → `M0_AXI_*`
- SERV `o_dbus_*` → `wb2axi_write` → `M1_AXI_*`

## Sử dụng

### 1. Kết nối với AXI Interconnect

```verilog
// Instantiate SERV wrapper
serv_axi_wrapper #(
    .ADDR_WIDTH     (32),
    .DATA_WIDTH     (32),
    .ID_WIDTH       (4),
    .WITH_CSR       (1),
    .RESET_PC       (32'h0000_0000)
) u_serv_wrapper (
    .ACLK           (clk),
    .ARESETN        (rstn),
    .i_timer_irq    (timer_irq),
    
    // AXI Master 0 (Instruction)
    .M0_AXI_arid    (S00_AXI_arid),    // Connect to Interconnect S00 port
    .M0_AXI_araddr  (S00_AXI_araddr),
    // ... (all other M0_AXI_* signals)
    
    // AXI Master 1 (Data)
    .M1_AXI_awid    (S01_AXI_awid),    // Connect to Interconnect S01 port
    .M1_AXI_awaddr  (S01_AXI_awaddr),
    // ... (all other M1_AXI_* signals)
);
```

### 2. Kết nối với AXI Interconnect trong testbench

```verilog
// In AXI_Interconnect_Full instantiation:
AXI_Interconnect_Full #(
    .Masters_Num    (2),  // SERV wrapper provides 2 masters
    .Num_Of_Slaves  (2),
    // ... other parameters
) u_interconnect (
    // Master 0 (Instruction Bus)
    .S00_AXI_arid       (serv_wrapper_M0_AXI_arid),
    .S00_AXI_araddr     (serv_wrapper_M0_AXI_araddr),
    // ...
    
    // Master 1 (Data Bus)
    .S01_AXI_awid       (serv_wrapper_M1_AXI_awid),
    .S01_AXI_awaddr     (serv_wrapper_M1_AXI_awaddr),
    // ...
);
```

## Lưu ý

1. **Reset Polarity:**
   - SERV sử dụng `i_rst` (active-high)
   - AXI sử dụng `ARESETN` (active-low)
   - Wrapper tự động chuyển đổi: `i_rst = ~ARESETN`

2. **RF (Register File) Interface:**
   - SERV cần Register File implementation
   - Hiện tại wrapper có placeholder cho RF
   - Cần implement `serv_rf_ram` hoặc RF module khác

3. **QoS Settings:**
   - Instruction bus có thể set QoS cao hơn data bus
   - Sử dụng `M0_AXI_arqos` và `M1_AXI_awqos/arqos` để điều chỉnh

4. **Address Mapping:**
   - Đảm bảo address ranges được map đúng trong AXI Interconnect
   - Instruction bus thường map đến ROM/Flash
   - Data bus map đến RAM/Peripherals

## Testing

1. Tạo testbench kết nối wrapper với AXI Interconnect
2. Load RISC-V test program vào memory
3. Verify instruction fetch qua M0_AXI
4. Verify data read/write qua M1_AXI
5. Check timing và handshake signals

## Tài liệu tham khảo

- SERV RISC-V: https://github.com/olofk/serv
- AXI4 Protocol Specification (ARM IHI 0022E)
- Wishbone B4 Specification
