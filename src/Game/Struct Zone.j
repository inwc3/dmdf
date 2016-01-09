library StructGameZone requires Asl, StructGameCharacter, StructGameQuestArea, StructGameMapChanger

	struct Zone extends QuestArea
		public static constant integer unitTypeId = 'n06N'
		private static AIntegerVector m_zones
		private string m_mapName
		private unit m_iconUnit
		
		public static method zones takes nothing returns AIntegerVector
			return thistype.m_zones
		endmethod
		
		public method mapName takes nothing returns string
			return this.m_mapName
		endmethod
		
		public stub method onCheck takes nothing returns boolean
			return true
		endmethod
		
		/**
		 * \note Is called with .execute().
		 */
		public stub method onStart takes nothing returns nothing
			call MapChanger.changeMap(this.m_mapName)
		endmethod
		
		public static method create takes string mapName, rect whichRect returns thistype
			local thistype this = thistype.allocate(whichRect)
			set this.m_mapName = mapName
			call this.setDestroyOnActivation(false)
			call thistype.m_zones.pushBack(this)
			set this.m_iconUnit = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), thistype.unitTypeId, GetRectCenterX(whichRect), GetRectCenterY(whichRect), 0.0)
			call SetUnitInvulnerable(this.m_iconUnit, true)
			call SetUnitPathing(this.m_iconUnit, false)
			call UnitSetUsesAltIcon(this.m_iconUnit, true)
			return this
		endmethod
		
		public static method onInit takes nothing returns nothing
			set thistype.m_zones = AIntegerVector.create()
			call SetAltMinimapIcon("UI\\Minimap\\MiniMap-Entrance.blp")
		endmethod
	endstruct
	
endlibrary