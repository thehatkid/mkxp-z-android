#ifndef FLUIDSTREAM_H
#define FLUIDSTREAM_H

#ifdef __cplusplus
extern "C" {
#endif

void* fluid_sf_open(const char* filename);
int fluid_sf_read(void* buf, long long count, void* handle);
int fluid_sf_seek(void* handle, long long offset, int origin);
long long fluid_sf_tell(void* handle);
int fluid_sf_close(void* handle);

#ifdef __cplusplus
}
#endif

#endif // FLUIDSTREAM_H