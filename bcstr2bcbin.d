/**
 * bcstr2bcbin - Converts string bytecode to binary bytecode.
 *
 * Description:
 *
 * Given a file containing textual Ethereum Virtual Machine (EVM) bytecode,
 * this program will convert the textual bytecode to an output file containing
 * binary format of the bytecode.
 */
import std.bigint;
import std.conv;
import std.file;
import std.range;
import std.stdio;

/**
 * Converts a long hexadecimal string into an array of bytes.
 *
 * Params:
 *      byteString = A string containing hexadecimal bytes.
 *
 * Returns: An array of bytes in the same order they appear in the string.
 */
ubyte[] byteStringToByteArray(string byteString) {
  ubyte[] binaryBytecode;

  foreach (i; iota(0, byteString.length, 2)) {
    string nextByte = byteString[i..(i + 2)];
    binaryBytecode ~= parse!ubyte(nextByte, 16);
  }

  return binaryBytecode;
}

int main(string[] args) {
  if (args.length < 3) {
    writeln("Usage: bcstr2bcbin [INPUT] [OUTPUT]");
    writeln("Converts string EVM bytecode to binary bytecode");
    return 1;
  }

  string inputFile = args[1];
  if (!inputFile.exists) {
    writeln("bcstr2bcbin: error: unable to find file ", inputFile);
    return 1;
  }

  string outputFile = args[2];
  if (outputFile.exists) {
    writeln("bcstr2bcbin: error: output file already exists ", outputFile);
    return 1;
  }

  writeln("Reading ", inputFile, "...");
  string vmBytes = readText(inputFile);

  writeln("Converting to binary...");
  ubyte[] binaryBytecode = byteStringToByteArray(vmBytes);

  writeln("Writing to ", outputFile, "...");
  std.file.write(outputFile, binaryBytecode);

  return 0;
}
