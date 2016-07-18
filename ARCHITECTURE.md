# EVM Machine Architecture

The Ethereum Virtual Machine (EVM) is a stack-based virtual machine for
executing Ethereum smart contracts. This document describes the basic
architecture of the machine and defines all of the available instructions.

## The Basics

### Machine Word and Stack

The EVM is a big-endian, stack-based machine architecture. The machine uses
256-bit words in order to facilitate SHA3-256 hash values and elliptic curve
computations.

The machine stack has a maximum depth of 1024 items.

### Memory Model

Memory for the EVM is word rather than byte addressable. All storage and memory
is initialized to zero.

Programs are not stored in memory, but instead can be considered to be stored
in virtual read-only memory (ROM) that is accessible only through a special
instruction.

## Opcodes

This section briefly defines each opcode used by the Ethereum virtual machine.
