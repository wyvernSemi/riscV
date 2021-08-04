# Create clean libraries
foreach lib [list work] {
  file delete -force -- $lib
  vlib $lib
}

