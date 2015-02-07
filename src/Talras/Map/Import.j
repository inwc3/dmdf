//! import "Talras/Map/Struct Aos.j"
//! import "Talras/Map/Struct Arena.j"
//! import "Talras/Map/Struct Fellows.j"
//! import "Talras/Map/Struct Map Data.j"
static if (DMDF_NPC_ROUTINES) then
//! import "Talras/Map/Struct Npc Routines.j"
endif
//! import "Talras/Map/Struct Npcs.j"
//! import "Talras/Map/Struct Shrines.j"
//! import "Talras/Map/Struct Spawn Points.j"
//! import "Talras/Map/Struct Tavern.j"

library MapMap requires StructMapMapAos, StructMapMapArena, StructMapMapFellows, StructMapMapMapData, optional StructMapMapNpcRoutines, StructMapMapNpcs, StructMapMapShrines, StructMapMapSpawnPoints, StructMapMapTavern
endlibrary