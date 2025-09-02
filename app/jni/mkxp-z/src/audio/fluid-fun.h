#ifndef FLUIDFUN_H
#define FLUIDFUN_H

#ifdef SHARED_FLUID
# include <fluidsynth.h>
#else
# define FLUIDSYNTH_VERSION_MAJOR 3
#endif

typedef struct _fluid_hashtable_t fluid_settings_t;
typedef struct _fluid_synth_t fluid_synth_t;
typedef struct _fluid_sfloader_t fluid_sfloader_t;
typedef int (*fluid_sfloader_callback_close_t)(void* handle);
typedef void* (*fluid_sfloader_callback_open_t)(const char* filename);
typedef int (*fluid_sfloader_callback_read_t)(void* buf, long long count, void* handle);
typedef int (*fluid_sfloader_callback_seek_t)(void* handle, long long offset, int origin);
typedef long long (*fluid_sfloader_callback_tell_t)(void* handle);


typedef int (*FLUIDSETTINGSSETNUMPROC)(fluid_settings_t* settings, const char *name, double val);
typedef int (*FLUIDSETTINGSSETINTPROC)(fluid_settings_t* settings, const char *name, int val);
typedef int (*FLUIDSETTINGSSETSTRPROC)(fluid_settings_t* settings, const char *name, const char *str);
typedef int (*FLUIDSYNTHSFLOADPROC)(fluid_synth_t* synth, const char* filename, int reset_presets);
typedef void (*FLUIDSYNTHADDSFLOADER)(fluid_synth_t* synth, fluid_sfloader_t* loader);	
typedef int (*FLUIDSYNTHSYSTEMRESETPROC)(fluid_synth_t* synth);
typedef int (*FLUIDSYNTHWRITES16PROC)(fluid_synth_t* synth, int len, void* lout, int loff, int lincr, void* rout, int roff, int rincr);
typedef int (*FLUIDSYNTHNOTEONPROC)(fluid_synth_t* synth, int chan, int key, int vel);
typedef int (*FLUIDSYNTHNOTEOFFPROC)(fluid_synth_t* synth, int chan, int key);
typedef int (*FLUIDSYNTHCHANNELPRESSUREPROC)(fluid_synth_t* synth, int chan, int val);
typedef int (*FLUIDSYNTHPITCHBENDPROC)(fluid_synth_t* synth, int chan, int val);
typedef int (*FLUIDSYNTHCCPROC)(fluid_synth_t* synth, int chan, int ctrl, int val);
typedef int (*FLUIDSYNTHPROGRAMCHANGEPROC)(fluid_synth_t* synth, int chan, int program);
typedef int (*FLUIDSFLOADERSETCALLBACKS)(fluid_sfloader_t* loader, fluid_sfloader_callback_open_t open, fluid_sfloader_callback_read_t read, fluid_sfloader_callback_seek_t seek, fluid_sfloader_callback_tell_t tell, fluid_sfloader_callback_close_t close);

typedef fluid_settings_t* (*NEWFLUIDSETTINGSPROC)(void);
typedef fluid_synth_t* (*NEWFLUIDSYNTHPROC)(fluid_settings_t* settings);
typedef fluid_sfloader_t* (*NEWFLUIDDEFSFLOADERPROC)(fluid_settings_t* settings);
typedef void (*DELETEFLUIDSETTINGSPROC)(fluid_settings_t* settings);

#if FLUIDSYNTH_VERSION_MAJOR == 1
typedef int (*DELETEFLUIDSYNTHPROC)(fluid_synth_t* synth);
#else
typedef void (*DELETEFLUIDSYNTHPROC)(fluid_synth_t* synth);
#endif

#define FLUID_FUNCS \
	FLUID_FUN(settings_setnum, FLUIDSETTINGSSETNUMPROC) \
    FLUID_FUN(settings_setint, FLUIDSETTINGSSETINTPROC) \
	FLUID_FUN(settings_setstr, FLUIDSETTINGSSETSTRPROC) \
	FLUID_FUN(synth_sfload, FLUIDSYNTHSFLOADPROC) \
	FLUID_FUN(synth_add_sfloader, FLUIDSYNTHADDSFLOADER) \
	FLUID_FUN(synth_system_reset, FLUIDSYNTHSYSTEMRESETPROC) \
	FLUID_FUN(synth_write_s16, FLUIDSYNTHWRITES16PROC) \
	FLUID_FUN(synth_noteon, FLUIDSYNTHNOTEONPROC) \
	FLUID_FUN(synth_noteoff, FLUIDSYNTHNOTEOFFPROC) \
	FLUID_FUN(synth_channel_pressure, FLUIDSYNTHCHANNELPRESSUREPROC) \
	FLUID_FUN(synth_pitch_bend, FLUIDSYNTHPITCHBENDPROC) \
	FLUID_FUN(synth_cc, FLUIDSYNTHCCPROC) \
	FLUID_FUN(synth_program_change, FLUIDSYNTHPROGRAMCHANGEPROC) \
	FLUID_FUN(sfloader_set_callbacks, FLUIDSFLOADERSETCALLBACKS)

/* Functions that don't fit into the default prefix naming scheme */
#define FLUID_FUNCS2 \
	FLUID_FUN2(new_settings, NEWFLUIDSETTINGSPROC, new_fluid_settings) \
	FLUID_FUN2(new_defsfloader, NEWFLUIDDEFSFLOADERPROC, new_fluid_defsfloader) \
	FLUID_FUN2(new_synth, NEWFLUIDSYNTHPROC, new_fluid_synth) \
	FLUID_FUN2(delete_settings, DELETEFLUIDSETTINGSPROC, delete_fluid_settings) \
	FLUID_FUN2(delete_synth, DELETEFLUIDSYNTHPROC, delete_fluid_synth)

struct FluidFunctions
{
#define FLUID_FUN(name, type) type name;
#define FLUID_FUN2(name, type, rn) type name;
	FLUID_FUNCS
	FLUID_FUNCS2
#undef FLUID_FUN
#undef FLUID_FUN2
};

#define HAVE_FLUID fluid.new_synth

extern FluidFunctions fluid;

void initFluidFunctions();

#endif // FLUIDFUN_H
