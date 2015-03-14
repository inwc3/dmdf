library StructMapMapArena requires Asl, StructGameClasses, StructGameGame, StructMapQuestsQuestArenaChampion

	struct Arena
		private static constant integer maxUnits = 2
		// static construction members
		private static real m_outsideX
		private static real m_outsideY
		private static real m_outsideFacing
		private static string m_textEnter
		private static string m_textLeave
		private static string m_textStartFight
		private static string m_textEndFight
		// static members
		private static ARealVector m_startX
		private static ARealVector m_startY
		private static ARealVector m_startFacing
		private static AUnitVector m_units
		private static integer array m_playerScore[6] /// \todo \ref MapData.maxPlayers
		private static unit m_winner
		private static region m_region
		private static trigger m_killTrigger
		private static trigger m_leaveTrigger
		private static leaderboard m_leaderboard

		//! runtextmacro optional A_STRUCT_DEBUG("\"Arena\"")

		public static method removeUnitByIndex takes integer index returns nothing
			local unit usedUnit = thistype.m_units[index]
			local player owner = GetOwningPlayer(usedUnit)
			call thistype.m_units.erase(index)
			call LeaderboardRemoveItem(thistype.m_leaderboard, index)
			if (ACharacter.getCharacterByUnit(usedUnit) != 0) then
				if (IsUnitDeadBJ(usedUnit)) then
					call ReviveHero(usedUnit, thistype.m_outsideX, thistype.m_outsideY, true)
					call SetUnitFacing(usedUnit, thistype.m_outsideFacing)
					call SetUnitInvulnerable(usedUnit, false)
					call PauseUnit(usedUnit, false)
					call IssueImmediateOrder(usedUnit, "stop")
				else
					call SetUnitX(usedUnit, thistype.m_outsideX)
					call SetUnitY(usedUnit, thistype.m_outsideY)
					call SetUnitFacing(usedUnit, thistype.m_outsideFacing)
					call SetUnitInvulnerable(usedUnit, false)
					call PauseUnit(usedUnit, false)
					call IssueImmediateOrder(usedUnit, "stop")
				endif

				call PanCameraToForPlayer(owner, GetUnitX(usedUnit), GetUnitY(usedUnit))
				call ShowLeaderboardForPlayer(owner, thistype.m_leaderboard, false)
				// remove player item to make sure the leaderboard is not restored after cinematics
				// remove item after hiding since hiding sets the leaderboard of the player
				call LeaderboardRemovePlayerItemBJ(owner, thistype.m_leaderboard)
			// remove newly created NPC units
			else
				call RemoveUnit(usedUnit)
			endif
			
			call SetPlayerAllianceStateBJ(owner, MapData.arenaPlayer, bj_ALLIANCE_ALLIED)
			call SetPlayerAllianceStateBJ(MapData.arenaPlayer, owner, bj_ALLIANCE_ALLIED)
			
			set usedUnit = null
			set owner = null
		endmethod

		public static method removeUnit takes unit usedUnit returns nothing
			local integer index = thistype.m_units.find(usedUnit)
			if (index == -1) then
				return
			endif
			call thistype.removeUnitByIndex(index)
		endmethod

		public static method removeCharacter takes ACharacter character returns nothing
			call thistype.removeUnit(character.unit())
			call character.revival().enable()
			call character.revival().setEnableAgain(true)
			call character.displayMessage(ACharacter.messageTypeInfo, thistype.m_textLeave)
		endmethod

		private static method checkForEndFight takes nothing returns nothing
			local integer aliveCount = 0
			local integer i = 0
			loop
				exitwhen (i == thistype.m_units.size())
				if (not IsUnitDeadBJ(thistype.m_units[i])) then
					set aliveCount = aliveCount + 1
					if (aliveCount > 1) then
						set thistype.m_winner = null
						return
					else
						set thistype.m_winner = thistype.m_units[i]
					endif
				endif
				set i = i + 1
			endloop
			call thistype.endFight.execute()
		endmethod

		private static method triggerConditionIsFromArena takes nothing returns boolean
			local unit triggerUnit = GetTriggerUnit()
			local boolean result = thistype.m_units.contains(triggerUnit)
			set triggerUnit = null
			return result
		endmethod

		private static method triggerActionKill takes nothing returns nothing
			local unit killer = GetKillingUnit()
			local player killerOwner
			local integer i
			local integer aliveCount = 0
			// TODO check if the owner of the killer has a unit in the Arena not if the killer is in the arena
			if (thistype.m_units.contains(killer)) then
				set killerOwner = GetOwningPlayer(killer)
				set thistype.m_playerScore[GetPlayerId(killerOwner)] = thistype.m_playerScore[GetPlayerId(killerOwner)] + 1
				if (thistype.m_playerScore[GetPlayerId(killerOwner)] == 5 and ACharacter.playerCharacter(killerOwner) != 0) then
					call QuestArenaChampion.characterQuest(ACharacter.playerCharacter(killerOwner)).questItem(0).setState(AAbstractQuest.stateCompleted)
					call QuestArenaChampion.characterQuest(ACharacter.playerCharacter(killerOwner)).questItem(1).setState(AAbstractQuest.stateNew)
					call QuestArenaChampion.characterQuest(ACharacter.playerCharacter(killerOwner)).displayUpdate()
				endif
				call LeaderboardSetItemValue(thistype.m_leaderboard, LeaderboardGetPlayerIndex(thistype.m_leaderboard, killerOwner), thistype.m_playerScore[GetPlayerId(killerOwner)])
				call LeaderboardSortItemsByValue(thistype.m_leaderboard, true)
				set killerOwner = null
			endif
			set killer = null
			call thistype.checkForEndFight()
		endmethod

		private static method createKillTrigger takes nothing returns nothing
			set thistype.m_killTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(thistype.m_killTrigger, EVENT_PLAYER_UNIT_DEATH)
			call TriggerAddCondition(thistype.m_killTrigger, Condition(function thistype.triggerConditionIsFromArena))
			call TriggerAddAction(thistype.m_killTrigger, function thistype.triggerActionKill)
		endmethod

		private static method triggerActionLeave takes nothing returns nothing
			local unit triggerUnit = GetTriggerUnit()
			local ACharacter character = ACharacter.getCharacterByUnit(triggerUnit)
			local integer i
			if (character == 0) then
				// increase score for all other unit's owner
				set i = 0
				loop
					exitwhen (i == thistype.m_units.size())
					if (GetOwningPlayer(thistype.m_units[i]) != GetOwningPlayer(triggerUnit)) then
						set thistype.m_playerScore[GetPlayerId(GetOwningPlayer(thistype.m_units[i]))] = thistype.m_playerScore[GetPlayerId(GetOwningPlayer(thistype.m_units[i]))] + 1
						call LeaderboardSetItemValue(thistype.m_leaderboard, LeaderboardGetPlayerIndex(thistype.m_leaderboard, GetOwningPlayer(thistype.m_units[i])), thistype.m_playerScore[GetPlayerId(GetOwningPlayer(thistype.m_units[i]))])
						call LeaderboardSortItemsByValue(thistype.m_leaderboard, true)
					endif
					set i = i + 1
				endloop
				
				// remove unit
				call thistype.removeUnit(triggerUnit)
			else
				// increase score for computer player
				set thistype.m_playerScore[GetPlayerId(MapData.arenaPlayer)] = thistype.m_playerScore[GetPlayerId(MapData.arenaPlayer)] + 1
				call LeaderboardSetItemValue(thistype.m_leaderboard, LeaderboardGetPlayerIndex(thistype.m_leaderboard, MapData.arenaPlayer), thistype.m_playerScore[GetPlayerId(MapData.arenaPlayer)])
				call LeaderboardSortItemsByValue(thistype.m_leaderboard, true)
				
				// remove character
				call thistype.removeCharacter(character)
			endif
			set triggerUnit = null
			call thistype.checkForEndFight()
		endmethod

		private static method createLeaveTrigger takes nothing returns nothing
			set thistype.m_leaveTrigger = CreateTrigger()
			call TriggerRegisterLeaveRegion(thistype.m_leaveTrigger, thistype.m_region, null)
			call TriggerAddCondition(thistype.m_leaveTrigger, Condition(function thistype.triggerConditionIsFromArena))
			call TriggerAddAction(thistype.m_leaveTrigger, function thistype.triggerActionLeave)
			call DisableTrigger(thistype.m_leaveTrigger)
		endmethod

		private static method createLeaderboard takes nothing returns nothing
			set thistype.m_leaderboard = CreateLeaderboard()
			call LeaderboardSetLabel(thistype.m_leaderboard, tr("Arena:"))
			call LeaderboardSetStyle(thistype.m_leaderboard, true, true, true, true)
			call LeaderboardDisplay(thistype.m_leaderboard, false)
		endmethod

		public static method init takes real outsideX, real outsideY, real outsideFacing, string textEnter, string textLeave, string textStartFight, string textEndFight returns nothing
			local integer i
			// static construction members
			set thistype.m_outsideX = outsideX
			set thistype.m_outsideY = outsideY
			set thistype.m_outsideFacing = outsideFacing
			set thistype.m_textEnter = textEnter
			set thistype.m_textLeave = textLeave
			set thistype.m_textStartFight = textStartFight
			set thistype.m_textEndFight = textEndFight
			// static members
			set thistype.m_startX = ARealVector.create()
			set thistype.m_startY = ARealVector.create()
			set thistype.m_startFacing = ARealVector.create()
			set thistype.m_units = AUnitVector.create()
			set i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				set thistype.m_playerScore[i] = 0
				call SetPlayerAllianceStateBJ(Player(i), MapData.arenaPlayer, bj_ALLIANCE_ALLIED)
				call SetPlayerAllianceStateBJ(MapData.arenaPlayer, Player(i), bj_ALLIANCE_ALLIED)
				set i = i + 1
			endloop
			set thistype.m_winner = null
			set thistype.m_region = CreateRegion()

			call thistype.createKillTrigger()
			call thistype.createLeaveTrigger()
			call thistype.createLeaderboard()
		endmethod

		public static method cleanUp takes nothing returns nothing
			// static members
			call thistype.m_startX.destroy()
			call thistype.m_startY.destroy()
			call thistype.m_startFacing.destroy()
			call thistype.m_units.destroy()
			set thistype.m_winner = null
			call RemoveRegion(thistype.m_region)
			set thistype.m_region = null
			call DestroyTrigger(thistype.m_killTrigger)
			set thistype.m_killTrigger = null
			call DestroyTrigger(thistype.m_leaveTrigger)
			set thistype.m_leaveTrigger = null
			call DestroyLeaderboard(thistype.m_leaderboard)
			set thistype.m_leaderboard = null
		endmethod

		// static members

		public static method playerScore takes player user returns integer
			return thistype.m_playerScore[GetPlayerId(user)]
		endmethod

		public static method winner takes nothing returns unit
			return thistype.m_winner
		endmethod

		// static methods

		public static method addRect takes rect usedRect returns nothing
			call RegionAddRect(thistype.m_region, usedRect)
		endmethod

		public static method addStartPoint takes real x, real y, real facing returns nothing
			debug if (thistype.m_startX.size() == thistype.maxUnits) then
				debug call thistype.staticPrint("Reached unit maximum.")
				debug return
			debug endif
			call thistype.m_startX.pushBack(x)
			call thistype.m_startY.pushBack(y)
			call thistype.m_startFacing.pushBack(facing)
		endmethod

		private static method startFight takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == thistype.m_units.size())
				call SetUnitInvulnerable(thistype.m_units[i], false)
				call PauseUnit(thistype.m_units[i], false)
				set i = i + 1
			endloop
			call EnableTrigger(thistype.m_killTrigger)
			call EnableTrigger(thistype.m_leaveTrigger)
			call ACharacter.displayMessageToAll(ACharacter.messageTypeInfo, thistype.m_textStartFight)
		endmethod

		public static method addUnit takes unit usedUnit returns nothing
			local player owner = GetOwningPlayer(usedUnit)
			call thistype.m_units.pushBack(usedUnit)
			call SetUnitX(usedUnit, thistype.m_startX[thistype.m_units.backIndex()])
			call SetUnitY(usedUnit, thistype.m_startY[thistype.m_units.backIndex()])
			call SetUnitFacing(usedUnit, thistype.m_startFacing[thistype.m_units.backIndex()])
			call SetUnitInvulnerable(usedUnit, true)
			call PauseUnit(usedUnit, true)
			call LeaderboardAddItemBJ(owner, thistype.m_leaderboard, GetUnitName(usedUnit) + ":", thistype.playerScore(owner))
			if (Character.getCharacterByUnit(usedUnit) == 0 and owner != MapData.arenaPlayer) then
				call SetUnitOwner(usedUnit, MapData.arenaPlayer, true)
			elseif (Character.getCharacterByUnit(usedUnit) != 0) then
				call PanCameraToForPlayer(owner, GetUnitX(usedUnit), GetUnitY(usedUnit))
				call ShowLeaderboardForPlayer(owner, thistype.m_leaderboard, true)
			endif
			if (thistype.m_units.size() == thistype.maxUnits) then
				call thistype.startFight()
			endif
			
			call SetPlayerAllianceStateBJ(owner, MapData.arenaPlayer, bj_ALLIANCE_UNALLIED)
			call SetPlayerAllianceStateBJ(MapData.arenaPlayer, owner, bj_ALLIANCE_UNALLIED)
			
			set owner = null
		endmethod

		public static method addCharacter takes ACharacter character returns nothing
			call thistype.addUnit(character.unit())
			call character.revival().disable()
			call character.revival().setEnableAgain(false)
			call character.displayMessage(ACharacter.messageTypeInfo, thistype.m_textEnter)
		endmethod

		public static method isFree takes nothing returns boolean
			debug call Print("Units size is " + I2S(thistype.m_units.size()))
			return thistype.m_units.size() < thistype.maxUnits
		endmethod

		/**
		* @todo Fix unit types.
		* h00D is level 6 enemy.
		*/
		public static method getRandomEnemy takes ACharacter character returns unit
			if (Classes.isChaplain(character.class())) then
				return CreateUnit(MapData.arenaPlayer, 'h019', 0.0, 0.0, 0.0)
			elseif (Classes.isMage(character.class())) then
				if (character.level() < 6) then
					return CreateUnit(MapData.arenaPlayer, 'h018', 0.0, 0.0, 0.0)
				else
					return CreateUnit(MapData.arenaPlayer, 'h01A', 0.0, 0.0, 0.0)
				endif
			elseif (Classes.isWarrior(character.class())) then
				if (character.level() < 6) then
					return CreateUnit(MapData.arenaPlayer, 'h017', 0.0, 0.0, 0.0)
				else
					return CreateUnit(MapData.arenaPlayer, 'h00D', 0.0, 0.0, 0.0)
				endif
			endif
			return null
		endmethod

		private static method endFight takes nothing returns nothing
			// pause units
			call DisableTrigger(thistype.m_killTrigger)
			call DisableTrigger(thistype.m_leaveTrigger)
			call TriggerSleepAction(3.0)
			loop
				exitwhen (thistype.m_units.empty())
				call thistype.removeUnitByIndex(thistype.m_units.backIndex())
			endloop
			call ACharacter.displayMessageToAll(ACharacter.messageTypeInfo, StringArg(thistype.m_textEndFight, GetUnitName(thistype.m_winner)))
		endmethod
	endstruct

endlibrary