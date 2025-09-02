#include "fluidstream.h"

#include <SDL_rwops.h>

void* fluid_sf_open(const char* filename)
{
    return SDL_RWFromFile(filename, "rb");
}

int fluid_sf_read(void* buf, long long count, void* handle)
{
    SDL_RWread((SDL_RWops*)(handle), buf, sizeof(char), count);
    return 0;
}
 
int fluid_sf_seek(void* handle, long long offset, int origin)
{
    SDL_RWseek((SDL_RWops*)(handle), offset, origin);
    return 0;
}
 
long long fluid_sf_tell(void* handle)
{
    return SDL_RWtell((SDL_RWops*)(handle));
}
 
int fluid_sf_close(void* handle)
{
    SDL_RWclose((SDL_RWops*)(handle));
    return 0;
}