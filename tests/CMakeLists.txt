if(libswiftnav_BUILD_TEST_LIBS)
  add_subdirectory(common)
endif()

if(libswiftnav_BUILD_TESTS)
  find_package(Threads)

  set(SRCS
      check_almanac.c
      check_bits.c
      check_coord_system.c
      check_edc.c
      check_ephemeris.c
      check_glo_map.c
      check_gnss_time.c
      check_gnss_time_cpp.cc
      check_ionosphere.c
      check_linear_algebra.c
      check_main.c
      check_nav_meas.c
      check_set.c
      check_shm.c
      check_sid_set.c
      check_signal.c
      check_pvt.c
      check_troposphere.c)

  swift_add_test(test-swiftnav-common
    POST_BUILD
    SRCS ${SRCS}
    LINK check-utils check Threads::Threads
    )
endif(libswiftnav_BUILD_TESTS)
