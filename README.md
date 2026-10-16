# packer.lua
Simple directory tree packager

# Usage

lua packer.lua <in_directory> <out_file>

# Package format

Header:

* 4 Bytes little-endian unsigned integer (magic number): 69696767
* 4 Bytes little-endian unsigned integer (number of files)
* For each file found in the directory tree:
  * Null-terminated ASCII string for the file's path (doesn't include the root directory)
  * 4 Bytes little-endian unsigned integer (file size in bytes)

Data:

Just all the files' bytes stored in a flat chunk in the same order as they appear in the header list.
