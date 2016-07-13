import core.stdc.stdlib;
import std.conv;
import std.file;
import std.stdio;
import std.traits;

// Constants defining the Ethereum opcodes
enum EvmOpcodes : ubyte {
  STOP = 0x00,
  ADD,
  MUL,
  SUB,
  DIV,
  SDIV,
  MOD,
  SMOD,
  ADDMOD,
  MULMOD,
  EXP,
  SIGNEXTEND,
  LT,
  GT,
  SLT,
  SGT,

  EQ = 0x10,
  ISZERO,
  AND,
  OR,
  XOR,
  NOT,
  BYTE,
  SHA3 = 0x20,

  ADDRESS = 0x30,
  BALANCE,
  ORIGIN,
  CALLER,
  CALLVALUE,
  CALLDATALOAD,
  CALLDATASIZE,
  CALLDATACOPY,
  CODESIZE,
  CODECOPY,
  GASPRICE,
  EXTCODESIZE,
  EXTCODECOPY,

  BLOCKHASH = 0x40,
  COINBASE,
  TIMESTAMP,
  NUMBER,
  DIFFICULTY,
  GASLIMIT,

  POP = 0x50,
  MLOAD,
  MSTORE,
  MSTORE8,
  SLOAD,
  SSTORE,
  JUMP,
  JUMPI,
  PC,
  MSIZE,
  GAS,
  JUMPDEST,

  PUSH1 = 0x60,
  PUSH2,
  PUSH3,
  PUSH4,
  PUSH5,
  PUSH6,
  PUSH7,
  PUSH8,
  PUSH9,
  PUSH10,
  PUSH11,
  PUSH12,
  PUSH13,
  PUSH14,
  PUSH15,
  PUSH16,
  PUSH17,
  PUSH18,
  PUSH19,
  PUSH20,
  PUSH21,
  PUSH22,
  PUSH23,
  PUSH24,
  PUSH25,
  PUSH26,
  PUSH27,
  PUSH28,
  PUSH29,
  PUSH30,
  PUSH31,
  PUSH32,
  DUP1,
  DUP2,
  DUP3,
  DUP4,
  DUP5,
  DUP6,
  DUP7,
  DUP8,
  DUP9,
  DUP10,
  DUP11,
  DUP12,
  DUP13,
  DUP14,
  DUP15,
  DUP16,
  SWAP1,
  SWAP2,
  SWAP3,
  SWAP4,
  SWAP5,
  SWAP6,
  SWAP7,
  SWAP8,
  SWAP9,
  SWAP10,
  SWAP11,
  SWAP12,
  SWAP13,
  SWAP14,
  SWAP15,
  SWAP16,

  LOG0 = 0xa0,
  LOG1,
  LOG2,
  LOG3,
  LOG4,

  CREATE = 0xf0,
  CALL,
  CALLCODE,
  RETURN,
  DELEGATECALL,
  SELFDESTRUCT = 0xff
}

pure string[ubyte] OpcodeNames() {
  string[ubyte] results;

  foreach (immutable opcode; [EnumMembers!EvmOpcodes]) {
    results[opcode] = std.conv.to!string(opcode);
  }

  return results;
}

int main(string[] args) {
  // Error if filename was not provided
  if (args.length < 2) {
    writeln("Usage: disassemble [FILENAME]");
    writeln("Takes a file containing binary smart contract bytecode and");
    writeln("prints the disassembled bytecode");
    return 1;
  }

  string filename = args[1];
  if (!filename.exists) {
     writeln("disassemble: error: unable to find file ", filename);
     return 1;
  }

  writeln(OpcodeNames[EvmOpcodes.STOP]);

  ubyte[] data = cast(ubyte[])read(filename);
  return 0;
}
