import core.stdc.stdlib;
import std.bigint;
import std.conv;
import std.file;
import std.range;
import std.stdio;
import std.traits;
import std.format;

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

/**
 * Converts a long hexadecimal string into an array of bytes.
 *
 * Params:
 *      hexString = A string containing hexadecimal bytes.
 *
 * Returns: An array of bytes in the same order they appear in the string.
 */
ubyte[] hexStringToByteArray(string hexString) {
  ubyte[] binaryBytecode;

  foreach (i; iota(0, hexString.length, 2)) {
    string nextByte = hexString[i..(i + 2)];
    binaryBytecode ~= parse!ubyte(nextByte, 16);
  }

  return binaryBytecode;
}

/**
 * Generates a mapping of opcode values to opcode names.
 *
 * Returns: An associative array from byte values to opcode name strings.
 */
pure string[ubyte] generateOpcodeToNameMap() {
  string[ubyte] results;

  foreach (immutable opcode; [EnumMembers!EvmOpcodes]) {
    results[opcode] = std.conv.to!string(opcode);
  }

  return results;
}

/**
 * Converts a series of bytes into a list of opcode names and arguments.
 *
 * Params:
 *      bytecode = Array of bytes containing Ethereum opcodes.
 *
 * Returns: An array of strings corresponding to opcodes. String opcodes are
 *      in same order as opcodes in byte array.
 */
string[] disassembleBytecode(ubyte[] bytecode) {
  string[] results;
  auto nameForOpcode = generateOpcodeToNameMap();

  for (size_t pc = 0; pc < bytecode.length; pc++) {
    auto opcode = bytecode[pc];

    switch(opcode) {
      case EvmOpcodes.PUSH1:
      case EvmOpcodes.PUSH2:
      case EvmOpcodes.PUSH3:
      case EvmOpcodes.PUSH4:
      case EvmOpcodes.PUSH5:
      case EvmOpcodes.PUSH6:
      case EvmOpcodes.PUSH7:
      case EvmOpcodes.PUSH8:
      case EvmOpcodes.PUSH9:
      case EvmOpcodes.PUSH10:
      case EvmOpcodes.PUSH11:
      case EvmOpcodes.PUSH12:
      case EvmOpcodes.PUSH13:
      case EvmOpcodes.PUSH14:
      case EvmOpcodes.PUSH15:
      case EvmOpcodes.PUSH16:
      case EvmOpcodes.PUSH17:
      case EvmOpcodes.PUSH18:
      case EvmOpcodes.PUSH19:
      case EvmOpcodes.PUSH20:
      case EvmOpcodes.PUSH21:
      case EvmOpcodes.PUSH22:
      case EvmOpcodes.PUSH23:
      case EvmOpcodes.PUSH24:
      case EvmOpcodes.PUSH25:
      case EvmOpcodes.PUSH26:
      case EvmOpcodes.PUSH27:
      case EvmOpcodes.PUSH28:
      case EvmOpcodes.PUSH29:
      case EvmOpcodes.PUSH30:
      case EvmOpcodes.PUSH31:
      case EvmOpcodes.PUSH32:
        // Get the number of bytes for the argument by doing some math on the
        // opcode. Produces a number in range [1, 32].
        size_t numBytes = (opcode - EvmOpcodes.PUSH1 + 1);
        // Iterate through the bytes for the argument and consolidate them into
        // a single integer value.
        BigInt arg = BigInt(0);
        for (ubyte i = 1; i <= numBytes; i++) {
          arg <<= 8;
          if (pc + i < bytecode.length) {
            arg |= bytecode[pc + i];
          }
        }
        results ~= format("%s 0x%032x", nameForOpcode[opcode], arg);
        // Ensure that we skip past the bytes for the argument
        pc += numBytes;
        break;
      default:
        if (opcode in nameForOpcode) {
          results ~= nameForOpcode[opcode];
        }
        break;
    }
  }

  return results;
}

int main(string[] args) {
  // Error if filename was not provided
  if (args.length < 3) {
    writeln("Usage: disassemble [INPUT] [OUTPUT]");
    writeln("Takes a file containing string smart contract bytecode and");
    writeln("prints the disassembled opcodes");
    return 1;
  }

  string inputFile = args[1];
  if (!inputFile.exists) {
     writeln("disassemble: error: unable to find file ", inputFile);
     return 1;
  }

  string outputFile = args[2];
  if (outputFile.exists) {
    writeln("bcstr2bcbin: error: output file already exists ", outputFile);
    return 1;
  }

  string vmBytes = readText(inputFile);
  ubyte[] vmBytecode = hexStringToByteArray(vmBytes);
  string[] result = disassembleBytecode(vmBytecode);

  File output = File(outputFile, "w");
  foreach (line; result) {
    output.writeln(line);
  }
  output.close();

  return 0;
}
