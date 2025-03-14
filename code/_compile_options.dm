//#define TESTING				//By using the testing("message") proc you can create debug-feedback for people with this
								//uncommented, but not visible in the release version)

//#define DATUMVAR_DEBUGGING_MODE	//Enables the ability to cache datum vars and retrieve later for debugging which vars changed.

// Comment this out if you are debugging problems that might be obscured by custom error handling in world/Error
#ifdef DEBUG
#define USE_CUSTOM_ERROR_HANDLER
#endif

#ifdef TESTING
#define DATUMVAR_DEBUGGING_MODE

///Method of tracking references.
//#define LEGACY_REFERENCE_TRACKING
#ifdef LEGACY_REFERENCE_TRACKING

///Should we be logging our findings or not
#define REFERENCE_TRACKING_LOG

///Use the legacy reference on things hard deleting by default.
//#define GC_FAILURE_HARD_LOOKUP
#ifdef GC_FAILURE_HARD_LOOKUP
#define FIND_REF_NO_CHECK_TICK
#endif //ifdef GC_FAILURE_HARD_LOOKUP

#endif //ifdef LEGACY_REFERENCE_TRACKING


//#define VISUALIZE_ACTIVE_TURFS	//Highlights atmos active turfs in green
#endif //ifdef TESTING

//#define UNIT_TESTS			//If this is uncommented, we do a single run though of the game setup and tear down process with unit tests in between

#ifndef PRELOAD_RSC				//set to:
#define PRELOAD_RSC	0			//	0 to allow using external resources or on-demand behaviour;
#endif							//	1 to use the default behaviour;
								//	2 for preloading absolutely everything;

#ifdef LOWMEMORYMODE
#define FORCE_MAP "_maps/runtimestation.json"
#endif

//Update this whenever you need to take advantage of more recent byond features
#define MIN_COMPILER_VERSION 514
#define MIN_COMPILER_BUILD 1554
/*#if DM_VERSION < MIN_COMPILER_VERSION || DM_BUILD < MIN_COMPILER_BUILD
//Don't forget to update this part
#error Your version of BYOND is too out-of-date to compile this project. Go to https://secure.byond.com/download and update.
#error You need version 514.1554 or higher.
#endif*/

//Update this whenever the byond version is stable so people stop updating to hilariously broken versions
#define MAX_COMPILER_VERSION 514
#define MAX_COMPILER_BUILD 1557
#if DM_VERSION > MAX_COMPILER_VERSION || DM_BUILD > MAX_COMPILER_BUILD
#warn WARNING: Your BYOND version is over the recommended version (514.1557)! Stability is not guaranteed.
#endif
//Log the full sendmaps profile on 514.1556+, any earlier and we get bugs or it not existing
#if DM_VERSION >= 514 && DM_BUILD >= 1556
#define SENDMAPS_PROFILE
#endif


//Additional code for the above flags.
#ifdef TESTING
#warn compiling in TESTING mode. testing() debug messages will be visible.
#endif

#ifdef CIBUILDING
#define UNIT_TESTS
#endif

#ifdef CITESTING
#define TESTING
#endif

#ifdef TGS
// TGS performs its own build of dm.exe, but includes a prepended TGS define.
#define CBT
#endif

#if !defined(CBT) && !defined(SPACEMAN_DMM)
/*#warn Building with Dream Maker is no longer supported and will result in errors.
#warn In order to build, run BUILD.bat in the root directory.
#warn Consider switching to VSCode editor instead, where you can press Ctrl+Shift+B to build.
#warn In order to compile this source, first run BUILD.bat in the root directory. Then compile with Dream Maker version 513.1542.
#warn To run this source, run with Dream Daemon version 513.1526.s
#warn These awkward restrictions are due to some janky things in this source. Will be resolved in the future. -Falaskian*/
#endif

#if DM_VERSION != 513 || DM_BUILD != 1542
#warn You are currently compiling with the wrong version! Please compile with 513.1542. Recommend running toolboxstation_compilable.dme.bat to open .dme with correct version! -KT
#else
#warn [Correct Compiler] Compiling with correct version. Congrats! You should host with 513.1526. Recommend running toolboxstation_dreamdaemon.bat to open correct version of dreamdaemon! -KT
#elif

#endif

#define EXTOOLS (world.system_type == MS_WINDOWS ? "byond-extools.dll" : "./libbyond-extools.so")
/*#define AUXMOS (world.system_type == MS_WINDOWS ? "auxtools/auxmos.dll" : __detect_auxmos())

/proc/__detect_auxmos()
	if (fexists("./libauxmos.so"))
		return "./libauxmos.so"
	else if (fexists("./auxtools/libauxmos.so"))
		return "./auxtools/libauxmos.so"
	else if (fexists("[world.GetConfig("env", "HOME")]/.byond/bin/libauxmos.so"))
		return "[world.GetConfig("env", "HOME")]/.byond/bin/libauxmos.so"
	else
		CRASH("Could not find libauxmos.so")*/
