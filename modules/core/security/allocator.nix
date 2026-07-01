# TODO: find a way to exclude apps from a hardened allocator
{
  # environment.memoryAllocator.provider = "graphene-hardened";

  # raised to handle the large number of guard pages that the hardened allocator creates
  # boot.kernel.sysctl."vm.max_map_count" = 1024 * 1024;
}
