# CPU Design Project

A two-part computer architecture project for **Computer Organization & Architecture**:

- **Part A** — A 16-bit CPU built in **Logisim**, composed of a register file, ALU, decimal decoder, and RAM.
- **Part B** — A 32-bit **MIPS-style processor** implemented in **VHDL**, with a complete GHDL simulation testbench suite.

## Repository Layout

```
CPU/
├── PartA_Logisim_16bit/     # 16-bit CPU in Logisim
│   ├── ALU_/                # 16-bit ALU circuit
│   ├── Registers_/          # Register file circuit
│   ├── Decimaldecoder_/     # Decimal decoder circuit
│   ├── CPU_/                # Top-level CPU circuit + RAM contents
│   └── truthtable.txt       # Control truth table
├── PartB_VHDL_32bit/
│   ├── src/                 # VHDL source (ALU, registers, memories, control)
│   ├── testbench/           # Testbenches for every module
│   └── waveforms/           # GHDL/GTKWave waveform dumps (generated)
├── Screenshots/             # Simulation result screenshots
└── Report.docx              # Final project report
```

## Part A — Logisim 16-bit CPU

1. Open `PartA_Logisim_16bit/CPU_/cpu.circ` in [Logisim](http://www.cburch.com/logisim/).
2. Load the RAM contents from `PartA_Logisim_16bit/CPU_/RAM content` (right-click RAM → Load Image).
3. Run the simulation (Simulate → Enabled, then tick the clock).

Individual subcircuits (ALU, Registers, Decimal decoder) can be opened from their own folders.

## Part B — VHDL 32-bit MIPS Processor

Modules in `PartB_VHDL_32bit/src/`:

| Module | Description |
|---|---|
| `ALU_32bit.vhd` | 32-bit ALU (add, sub, and, or, slt) with zero flag |
| `ALU_Control.vhd` | ALU operation decoder |
| `Control_Unit.vhd` | Main control unit |
| `Register_File_32bit.vhd` | 32 × 32-bit register file |
| `Data_Memory.vhd` | Data memory |
| `Instruction_Memory.vhd` | Instruction memory |

### Simulating with GHDL

```bash
cd PartB_VHDL_32bit

# Analyze sources
ghdl -a src/*.vhd

# Analyze + elaborate a testbench (example: ALU)
ghdl -a testbench/ALU_32bit_tb.vhd
ghdl -e ALU_32bit_tb
ghdl -r ALU_32bit_tb --wave=waveforms/ALU_32bit_wave.ghw

# View the waveform
gtkwave waveforms/ALU_32bit_wave.ghw
```

Testbenches are provided for the ALU, register file, control unit, instruction memory, and data memory. Simulation screenshots for each task are in `Screenshots/`.
