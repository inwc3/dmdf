library StructMapMapAos requires Asl, StructGameCharacter, StructMapMapMapData, StructMapMapShrines, StructMapMapNpcs

	/**
	 * \brief Provides an API for the map's AOS which is realized in the drum cave where two brothers are fighting each others with armies.
	 *
	 * The AOS area is defined in the rect gg_rct_area_aos.
	 *
	 * The AOS has two lines and two teams:
	 * <ul>
	 * <li>The White Legion of the arch angel Haldar</li>
	 * <li>The Black Legion of the arch demon Baldar</li>
	 * </ul>
	 *
	 * Each team spawns units periodically at both lines and sends them to the other team's camp.
	 * The spawn interval is defined by \ref spawnTime.
	 *
	 * The players for the two teams are defined in \ref MapData as \ref MapData.haldarPlayer and \ref  MapData.baldarPlayer.
	 *
	 * The characters can join one of the teams by using a special ring to transform themselves either in a demon or an angel without inventory and different abilities.
	 * If they join a team they get the chance not only to fight the other team's computer controlled units but also the other players of the other team.
	 * The owners of the characters get displayed a leaderboard for all "last hit" kills they do in the AOS area while being in one team.
	 * The kill count is important to get a reward from either Haldar or Baldar. This is part of the quest. You can use \ref playerScore() to get the corresponding score.
	 *
	 * Use \ref init() to initialize the whole AOS system.
	 *
	 * \note The spawn starts when the first character enters the area of the AOS. This should reduce the performance if the AOS is not used yet.
	 */
	struct Aos
		private static constant real spawnTime = 60.0
		private static player m_haldarsUser
		private static player m_baldarsUser
		private static integer m_haldarMembers
		private static integer m_baldarMembers
		private static boolean array m_playerHasJoinedHaldar[6] /// \todo \ref MapData.maxPlayers
		private static boolean array m_playerHasJoinedBaldar[6] /// \todo \ref MapData.maxPlayers
		private static integer array m_playerScore[6] /// \todo \ref MapData.maxPlayers
		private static leaderboard m_leaderboard
		private static trigger m_enterTrigger
		private static trigger m_leaveTrigger
		private static timer m_spawnTimer
		private static trigger m_scoreTrigger
		private static boolean m_characterHasEntered

		//! runtextmacro optional A_STRUCT_DEBUG("\"Aos\"")

		/**
		 * Continues the AOS spawn on both sides.
		 */
		public static method continueSpawn takes nothing returns nothing
			debug call Print("Continue spawn!")
			call PauseTimerBJ(false, thistype.m_spawnTimer)
		endmethod

		public static method pauseSpawn takes nothing returns nothing
			call PauseTimerBJ(true, thistype.m_spawnTimer)
		endmethod
		
		private static method timerFunctionSpawn takes nothing returns nothing
			local effect createdEffect
			local group haldarsGroup0 = CreateGroup()
			local group haldarsGroup1 = CreateGroup()
			local group baldarsGroup0 = CreateGroup()
			local group baldarsGroup1 = CreateGroup()
			local unit createdUnit
			debug call Print("AOS Spawn!")
			// Haldar
			if (not IsUnitPaused(Npcs.haldar())) then
				call SetUnitAnimation(Npcs.haldar(), "Spell Slam")
				call ResetUnitAnimation(Npcs.haldar())
				call DestroyEffect(AddSpecialEffect("Models\\Effects\\TeleportationZaubernder.mdx", GetUnitX(Npcs.haldar()), GetUnitY(Npcs.haldar())))
			endif
			call DestroyEffect(AddSpecialEffect("Models\\Effects\\Teleportation.mdx", GetRectCenterX(gg_rct_haldar_spawn_point_0), GetRectCenterY(gg_rct_haldar_spawn_point_0)))
			call DestroyEffect(AddSpecialEffect("Models\\Effects\\Teleportation.mdx", GetRectCenterX(gg_rct_haldar_spawn_point_1), GetRectCenterY(gg_rct_haldar_spawn_point_1)))
			// the white legion - group 0
			set createdUnit = CreateUnit(thistype.m_haldarsUser, 'n029', GetRectCenterX(gg_rct_haldar_spawn_point_0), GetRectCenterY(gg_rct_haldar_spawn_point_0), 270.0)
			call GroupAddUnit(haldarsGroup0, createdUnit)
			set createdUnit = null
			set createdUnit = CreateUnit(thistype.m_haldarsUser, 'n028', GetRectCenterX(gg_rct_haldar_spawn_point_0), GetRectCenterY(gg_rct_haldar_spawn_point_0), 270.0)
			call GroupAddUnit(haldarsGroup0, createdUnit)
			set createdUnit = null
			set createdUnit = CreateUnit(thistype.m_haldarsUser, 'n028', GetRectCenterX(gg_rct_haldar_spawn_point_0), GetRectCenterY(gg_rct_haldar_spawn_point_0), 270.0)
			call GroupAddUnit(haldarsGroup0, createdUnit)
			set createdUnit = null
			set createdUnit = CreateUnit(thistype.m_haldarsUser, 'n027', GetRectCenterX(gg_rct_haldar_spawn_point_0), GetRectCenterY(gg_rct_haldar_spawn_point_0), 270.0)
			call GroupAddUnit(haldarsGroup0, createdUnit)
			set createdUnit = null
			set createdUnit = CreateUnit(thistype.m_haldarsUser, 'n027', GetRectCenterX(gg_rct_haldar_spawn_point_0), GetRectCenterY(gg_rct_haldar_spawn_point_0), 270.0)
			call GroupAddUnit(haldarsGroup0, createdUnit)
			set createdUnit = null
			set createdUnit = CreateUnit(thistype.m_haldarsUser, 'n026', GetRectCenterX(gg_rct_haldar_spawn_point_0), GetRectCenterY(gg_rct_haldar_spawn_point_0), 270.0)
			call GroupAddUnit(baldarsGroup0, createdUnit)
			set createdUnit = null
			// the white legion - group 1
			set createdUnit = CreateUnit(thistype.m_haldarsUser, 'n029', GetRectCenterX(gg_rct_haldar_spawn_point_1), GetRectCenterY(gg_rct_haldar_spawn_point_1), 270.0)
			call GroupAddUnit(haldarsGroup0, createdUnit)
			set createdUnit = null
			set createdUnit = CreateUnit(thistype.m_haldarsUser, 'n028', GetRectCenterX(gg_rct_haldar_spawn_point_1), GetRectCenterY(gg_rct_haldar_spawn_point_1), 270.0)
			call GroupAddUnit(haldarsGroup0, createdUnit)
			set createdUnit = null
			set createdUnit = CreateUnit(thistype.m_haldarsUser, 'n028', GetRectCenterX(gg_rct_haldar_spawn_point_1), GetRectCenterY(gg_rct_haldar_spawn_point_1), 270.0)
			call GroupAddUnit(haldarsGroup0, createdUnit)
			set createdUnit = null
			set createdUnit = CreateUnit(thistype.m_haldarsUser, 'n027', GetRectCenterX(gg_rct_haldar_spawn_point_1), GetRectCenterY(gg_rct_haldar_spawn_point_1), 270.0)
			call GroupAddUnit(haldarsGroup0, createdUnit)
			set createdUnit = null
			set createdUnit = CreateUnit(thistype.m_haldarsUser, 'n027', GetRectCenterX(gg_rct_haldar_spawn_point_1), GetRectCenterY(gg_rct_haldar_spawn_point_1), 270.0)
			call GroupAddUnit(haldarsGroup0, createdUnit)
			set createdUnit = null
			set createdUnit = CreateUnit(thistype.m_haldarsUser, 'n00M', GetRectCenterX(gg_rct_haldar_spawn_point_1), GetRectCenterY(gg_rct_haldar_spawn_point_1), 270.0)
			call GroupAddUnit(haldarsGroup0, createdUnit)
			set createdUnit = null
			// move
			call GroupPointOrder(haldarsGroup0, "patrol", GetRectCenterX(gg_rct_baldar_spawn_point_0), GetRectCenterY(gg_rct_baldar_spawn_point_0))
			call GroupPointOrder(haldarsGroup1, "patrol", GetRectCenterX(gg_rct_baldar_spawn_point_1), GetRectCenterY(gg_rct_baldar_spawn_point_1))
			// baldar
			if (not IsUnitPaused(Npcs.baldar())) then
				call SetUnitAnimation(Npcs.baldar(), "Spell Slam")
				call ResetUnitAnimation(Npcs.baldar())
				call DestroyEffect(AddSpecialEffect("Models\\Effects\\TeleportationZaubernder.mdx", GetUnitX(Npcs.baldar()), GetUnitY(Npcs.baldar())))
			endif
			call DestroyEffect(AddSpecialEffect("Models\\Effects\\Teleportation.mdx", GetRectCenterX(gg_rct_baldar_spawn_point_0), GetRectCenterY(gg_rct_baldar_spawn_point_0)))
			call DestroyEffect(AddSpecialEffect("Models\\Effects\\Teleportation.mdx", GetRectCenterX(gg_rct_baldar_spawn_point_1), GetRectCenterY(gg_rct_baldar_spawn_point_1)))
			// the black legion - group 0
			set createdUnit = CreateUnit(thistype.m_baldarsUser, 'n00G', GetRectCenterX(gg_rct_baldar_spawn_point_0), GetRectCenterY(gg_rct_baldar_spawn_point_0), 90.0)
			call GroupAddUnit(baldarsGroup0, createdUnit)
			set createdUnit = null
			set createdUnit = CreateUnit(thistype.m_baldarsUser, 'n00I', GetRectCenterX(gg_rct_baldar_spawn_point_0), GetRectCenterY(gg_rct_baldar_spawn_point_0), 90.0)
			call GroupAddUnit(baldarsGroup0, createdUnit)
			set createdUnit = null
			set createdUnit = CreateUnit(thistype.m_baldarsUser, 'n00I', GetRectCenterX(gg_rct_baldar_spawn_point_0), GetRectCenterY(gg_rct_baldar_spawn_point_0), 90.0)
			call GroupAddUnit(baldarsGroup0, createdUnit)
			set createdUnit = null
			set createdUnit = CreateUnit(thistype.m_baldarsUser, 'n00I', GetRectCenterX(gg_rct_baldar_spawn_point_0), GetRectCenterY(gg_rct_baldar_spawn_point_0), 90.0)
			call GroupAddUnit(baldarsGroup0, createdUnit)
			set createdUnit = null
			// the black legion - group 1
			set createdUnit = CreateUnit(thistype.m_baldarsUser, 'n00J', GetRectCenterX(gg_rct_baldar_spawn_point_1), GetRectCenterY(gg_rct_baldar_spawn_point_1), 90.0)
			call GroupAddUnit(baldarsGroup1, createdUnit)
			set createdUnit = null
			set createdUnit = CreateUnit(thistype.m_baldarsUser, 'n00J', GetRectCenterX(gg_rct_baldar_spawn_point_1), GetRectCenterY(gg_rct_baldar_spawn_point_1), 90.0)
			call GroupAddUnit(baldarsGroup1, createdUnit)
			set createdUnit = null
			set createdUnit = CreateUnit(thistype.m_baldarsUser, 'n00I', GetRectCenterX(gg_rct_baldar_spawn_point_1), GetRectCenterY(gg_rct_baldar_spawn_point_1), 90.0)
			call GroupAddUnit(baldarsGroup1, createdUnit)
			set createdUnit = null
			set createdUnit = CreateUnit(thistype.m_baldarsUser, 'n00I', GetRectCenterX(gg_rct_baldar_spawn_point_1), GetRectCenterY(gg_rct_baldar_spawn_point_1), 90.0)
			call GroupAddUnit(baldarsGroup1, createdUnit)
			set createdUnit = null
			set createdUnit = CreateUnit(thistype.m_baldarsUser, 'n00I', GetRectCenterX(gg_rct_baldar_spawn_point_1), GetRectCenterY(gg_rct_baldar_spawn_point_1), 90.0)
			call GroupAddUnit(baldarsGroup1, createdUnit)
			set createdUnit = null
			// move
			call GroupPointOrder(baldarsGroup0, "patrol", GetRectCenterX(gg_rct_haldar_spawn_point_0), GetRectCenterY(gg_rct_haldar_spawn_point_0))
			call GroupPointOrder(baldarsGroup1, "patrol", GetRectCenterX(gg_rct_haldar_spawn_point_1), GetRectCenterY(gg_rct_haldar_spawn_point_1))

			call DestroyGroup(haldarsGroup0)
			set haldarsGroup0 = null
			call DestroyGroup(haldarsGroup1)
			set haldarsGroup1 = null
			call DestroyGroup(baldarsGroup0)
			set baldarsGroup0 = null
			call DestroyGroup(baldarsGroup1)
			set baldarsGroup1 = null
			
			debug call Print("AOS Spawn End!")
			debug call Print("AOS timeout: " + R2S(TimerGetTimeout(thistype.m_spawnTimer)))
		endmethod

		/**
		 * Character \p character joins the AOS area which changes the music and the camera bounds.
		 * \note If this is the first time a character enters the area, the AOS spawns start. This reduces performance issues if nobody ever enters the AOS area.
		 */
		public static method characterJoins takes Character character returns nothing
			local player user = character.player()
			call PlayMusic("Music\\TheDrumCave.mp3") /// @todo for user
			call MapData.setCameraBoundsToAosForPlayer.evaluate(user)
			call character.setCamera()
			if (not thistype.m_characterHasEntered) then
				set thistype.m_characterHasEntered = true
				/// @todo Play video The Vision.
				// black legion workers
				call IssueTargetOrder(gg_unit_u001_0190, "harvest", gg_dest_B00D_2651)
				call IssueTargetOrder(gg_unit_u001_0191, "harvest", gg_dest_B00D_8151)
				call IssueTargetOrder(gg_unit_u001_0192, "harvest", gg_dest_B00D_2623)
				
				call TimerStart(thistype.m_spawnTimer, thistype.spawnTime, true, function thistype.timerFunctionSpawn)
			endif
			set user = null
		endmethod

		public static method characterLeaves takes Character character returns nothing
			local player user = character.player()
			call StopMusic(false) /// @todo for user
			call MapData.setCameraBoundsToPlayableAreaForPlayer.evaluate(user) // set camera bounds before rect!
			call character.setCamera()
			set user = null
		endmethod
		
		private static method setCharacterAllianceStateToOthers takes Character character, boolean haldar returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (thistype.m_playerHasJoinedHaldar[i] and haldar) then
					call SetPlayerAllianceStateBJ(Player(i), character.player(), bj_ALLIANCE_ALLIED_VISION)
					call SetPlayerAllianceStateBJ(character.player(), Player(i), bj_ALLIANCE_ALLIED_VISION)
				elseif (thistype.m_playerHasJoinedHaldar[i] and not haldar) then
					call SetPlayerAllianceStateBJ(Player(i), character.player(), bj_ALLIANCE_UNALLIED)
					call SetPlayerAllianceStateBJ(character.player(), Player(i), bj_ALLIANCE_UNALLIED)
				elseif (thistype.m_playerHasJoinedBaldar[i] and haldar) then
					call SetPlayerAllianceStateBJ(Player(i), character.player(), bj_ALLIANCE_UNALLIED)
					call SetPlayerAllianceStateBJ(character.player(), Player(i), bj_ALLIANCE_UNALLIED)
				elseif (thistype.m_playerHasJoinedBaldar[i] and not haldar) then
					call SetPlayerAllianceStateBJ(Player(i), character.player(), bj_ALLIANCE_ALLIED_VISION)
					call SetPlayerAllianceStateBJ(character.player(), Player(i), bj_ALLIANCE_ALLIED_VISION)
				else
					if (character.player() == MAP_CONTROL_COMPUTER or GetPlayerController(Player(i)) == MAP_CONTROL_COMPUTER) then
						call SetPlayerAllianceStateBJ(Player(i), character.player(), bj_ALLIANCE_ALLIED_ADVUNITS)
						call SetPlayerAllianceStateBJ(character.player(), Player(i), bj_ALLIANCE_ALLIED_ADVUNITS)
					else
						call SetPlayerAllianceStateBJ(Player(i), character.player(), bj_ALLIANCE_ALLIED_VISION)
						call SetPlayerAllianceStateBJ(character.player(), Player(i), bj_ALLIANCE_ALLIED_VISION)
					endif
				endif
				set i = i + 1
			endloop
			if (haldar) then
				call SetPlayerAllianceStateBJ(thistype.m_haldarsUser, character.player(), bj_ALLIANCE_ALLIED_VISION)
				call SetPlayerAllianceStateBJ(thistype.m_baldarsUser, character.player(), bj_ALLIANCE_UNALLIED)
				call SetPlayerAllianceStateBJ(character.player(), thistype.m_haldarsUser, bj_ALLIANCE_ALLIED)
				call SetPlayerAllianceStateBJ(character.player(), thistype.m_baldarsUser, bj_ALLIANCE_UNALLIED)
			else
				call SetPlayerAllianceStateBJ(thistype.m_haldarsUser, character.player(), bj_ALLIANCE_UNALLIED)
				call SetPlayerAllianceStateBJ(thistype.m_baldarsUser, character.player(), bj_ALLIANCE_ALLIED_VISION)
				call SetPlayerAllianceStateBJ(character.player(), thistype.m_haldarsUser, bj_ALLIANCE_UNALLIED)
				call SetPlayerAllianceStateBJ(character.player(), thistype.m_baldarsUser, bj_ALLIANCE_ALLIED)
			endif
		endmethod
		
		private static method resetCharacterAllianceStateToOthers takes Character character returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (character.player() == MAP_CONTROL_COMPUTER or GetPlayerController(Player(i)) == MAP_CONTROL_COMPUTER) then
					call SetPlayerAllianceStateBJ(Player(i), character.player(), bj_ALLIANCE_ALLIED_ADVUNITS)
					call SetPlayerAllianceStateBJ(character.player(), Player(i), bj_ALLIANCE_ALLIED_ADVUNITS)
				else
					call SetPlayerAllianceStateBJ(Player(i), character.player(), bj_ALLIANCE_ALLIED_VISION)
					call SetPlayerAllianceStateBJ(character.player(), Player(i), bj_ALLIANCE_ALLIED_VISION)
				endif
				set i = i + 1
			endloop
				call SetPlayerAllianceStateBJ(thistype.m_haldarsUser, character.player(), bj_ALLIANCE_NEUTRAL)
			call SetPlayerAllianceStateBJ(thistype.m_baldarsUser, character.player(), bj_ALLIANCE_NEUTRAL)
			call SetPlayerAllianceStateBJ(character.player(), thistype.m_haldarsUser, bj_ALLIANCE_NEUTRAL)
			call SetPlayerAllianceStateBJ(character.player(), thistype.m_baldarsUser, bj_ALLIANCE_NEUTRAL)
		endmethod

		public static method characterJoinsHaldar takes Character character returns nothing
			local player user
			call character.setRect(gg_rct_haldar_start)
			call character.setFacing(270.0)
			call character.panCameraSmart()
			call character.displayMessage(ACharacter.messageTypeInfo, tr("Sie sind Haldars Truppe beigetreten."))
			call character.displayMessageToAllOthers(ACharacter.messageTypeInfo, StringArg("%s ist Haldars Truppe beigetreten.", character.name()))
			set user = character.player()
			call Shrines.aosShrineHaldar().enableForCharacter(character, false)
			set thistype.m_playerHasJoinedHaldar[GetPlayerId(user)] = true
			set thistype.m_haldarMembers = thistype.m_haldarMembers + 1
			call thistype.setCharacterAllianceStateToOthers(character, true)
			call LeaderboardAddItemBJ(user, thistype.m_leaderboard, character.name(), thistype.m_playerScore[GetPlayerId(user)])
			call ShowLeaderboardForPlayer(user, thistype.m_leaderboard, true)
			call character.setIsInPvp(true)
			set user = null
		endmethod

		public static method characterLeavesHaldar takes Character character returns nothing
			local player user = character.player()
			call character.displayMessageToAllOthers(ACharacter.messageTypeInfo, StringArg(tr("%s hat das Schlachtfeld und somit Haldars Truppe verlassen."), character.name()))
			set thistype.m_playerHasJoinedHaldar[GetPlayerId(user)] = false
			set thistype.m_haldarMembers = thistype.m_haldarMembers - 1
			call ShowLeaderboardForPlayer(user, thistype.m_leaderboard, false)
			call LeaderboardRemovePlayerItem(thistype.m_leaderboard, user)
			call thistype.resetCharacterAllianceStateToOthers(character)
			call character.setIsInPvp(false)
			set user = null
		endmethod

		public static method characterJoinsBaldar takes Character character returns nothing
			local player user
			call character.setRect(gg_rct_baldar_start)
			call character.setFacing(90.0)
			call character.panCameraSmart()
			call character.displayMessage(ACharacter.messageTypeInfo, tr("Sie sind Baldars Truppe beigetreten."))
			call character.displayMessageToAllOthers(ACharacter.messageTypeInfo, StringArg(tr("%s ist Baldars Truppe beigetreten."), character.name()))
			set user = character.player()
			call Shrines.aosShrineBaldar().enableForCharacter(character, false)
			set thistype.m_playerHasJoinedBaldar[GetPlayerId(user)] = true
			set thistype.m_baldarMembers = thistype.m_baldarMembers + 1
			call thistype.setCharacterAllianceStateToOthers(character, false)
			call LeaderboardAddItemBJ(user, thistype.m_leaderboard, character.name(), thistype.m_playerScore[GetPlayerId(user)])
			call ShowLeaderboardForPlayer(user, thistype.m_leaderboard, true)
			call character.setIsInPvp(true)
			set user = null
		endmethod

		public static method characterLeavesBaldar takes Character character returns nothing
			local player user = character.player()
			call character.displayMessageToAllOthers(ACharacter.messageTypeInfo, StringArg(tr("%s hat das Schlachtfeld und somit Baldars Truppe verlassen."), character.name()))
			set thistype.m_playerHasJoinedBaldar[GetPlayerId(user)] = false
			set thistype.m_baldarMembers = thistype.m_baldarMembers - 1
			call ShowLeaderboardForPlayer(user, thistype.m_leaderboard, false)
			call LeaderboardRemovePlayerItem(thistype.m_leaderboard, user)
			call thistype.resetCharacterAllianceStateToOthers(character)
			call character.setIsInPvp(false)
			set user = null
		endmethod

		public static method baldarContainsCharacter takes Character character returns boolean
			local player user = character.player()
			local boolean result = thistype.m_playerHasJoinedBaldar[GetPlayerId(user)]
			set user = null
			return result
		endmethod

		public static method haldarContainsCharacter takes Character character returns boolean
			local player user = character.player()
			local boolean result = thistype.m_playerHasJoinedHaldar[GetPlayerId(user)]
			set user = null
			return result
		endmethod

		public static method teamContainsCharacter takes Character character returns boolean
			local player user = character.player()
			local boolean result = thistype.m_playerHasJoinedHaldar[GetPlayerId(user)] or thistype.m_playerHasJoinedBaldar[GetPlayerId(user)]
			set user = null
			return result
		endmethod

		public static method areaContainsCharacter takes Character character returns boolean
			return RectContainsUnit(gg_rct_area_aos, character.unit())
		endmethod

		private static method createLeaderboard takes nothing returns nothing
			//local integer i
			//local player user
			set thistype.m_leaderboard = CreateLeaderboard()
			call LeaderboardSetLabel(thistype.m_leaderboard, tr("Schlachtfeld-Rangliste:"))
			call LeaderboardSetStyle(thistype.m_leaderboard, true, true, true, true)
			//Usually not required because ShowLeaderboardForPlayer does the same work.
			//set i = 0
			//loop
				//exitwhen (i == MapData.maxPlayers)
				//set user = Player(i)
				//if (IsPlayerPlayingUser(user)) then
					//call PlayerSetLeaderboard(user, Aos.leaderBoard)
				//endif
				//set user = null
				//set i = i + 1
			//endloop
			call LeaderboardDisplay(thistype.m_leaderboard, false)
		endmethod

		private static method triggerConditionIsCharacter takes nothing returns boolean
			return ACharacter.isUnitCharacter(GetTriggerUnit())
		endmethod

		private static method triggerActionEnter takes nothing returns nothing
			local unit triggerUnit = GetTriggerUnit()
			local Character character = ACharacter.getCharacterByUnit(triggerUnit)
			local player user = character.player()
			call thistype.characterJoins(character)
			set triggerUnit = null
			set user = null
		endmethod

		private static method createEnterTrigger takes nothing returns nothing
			set thistype.m_enterTrigger = CreateTrigger()
			call TriggerRegisterEnterRectSimple(thistype.m_enterTrigger, gg_rct_area_aos)
			call TriggerAddCondition(thistype.m_enterTrigger, Condition(function thistype.triggerConditionIsCharacter))
			call TriggerAddAction(thistype.m_enterTrigger, function thistype.triggerActionEnter)
		endmethod

		private static method triggerActionLeave takes nothing returns nothing
			local unit triggerUnit = GetTriggerUnit()
			local Character character = ACharacter.getCharacterByUnit(triggerUnit)
			local player user = character.player()
			call thistype.characterLeaves(character)
			set triggerUnit = null
			set user = null
		endmethod

		private static method createLeaveTrigger takes nothing returns nothing
			set thistype.m_leaveTrigger = CreateTrigger()
			call TriggerRegisterLeaveRectSimple(thistype.m_leaveTrigger, gg_rct_area_aos)
			call TriggerAddCondition(thistype.m_leaveTrigger, Condition(function thistype.triggerConditionIsCharacter))
			call TriggerAddAction(thistype.m_leaveTrigger, function thistype.triggerActionLeave)
		endmethod

		private static method createSpawnTimer takes nothing returns nothing
			set thistype.m_spawnTimer = CreateTimer()
		endmethod

		/// All player units can score (for example summoned units).
		private static method triggerConditionScore takes nothing returns boolean
			local unit triggerUnit = GetTriggerUnit()
			local unit killingUnit = GetKillingUnit()
			local player triggerOwner = GetOwningPlayer(triggerUnit)
			local player killingOwner = GetOwningPlayer(killingUnit)
			local boolean result  = true
			if (not thistype.teamContainsCharacter(ACharacter.playerCharacter(killingOwner))) then
				set result = false
			elseif (thistype.m_playerHasJoinedHaldar[GetPlayerId(killingOwner)] and triggerOwner != thistype.m_baldarsUser) then
				set result = false
			elseif (thistype.m_playerHasJoinedBaldar[GetPlayerId(killingOwner)] and triggerOwner != thistype.m_haldarsUser) then
				set result = false
			endif
			set triggerUnit = null
			set killingUnit = null
			set triggerOwner = null
			set killingOwner = null
			return result
		endmethod

		private static method triggerActionScore takes nothing returns nothing
			local unit killingUnit = GetKillingUnit()
			local player killingOwner = GetOwningPlayer(killingUnit)
			set thistype.m_playerScore[GetPlayerId(killingOwner)] = thistype.m_playerScore[GetPlayerId(killingOwner)] + 1
			call LeaderboardSetPlayerItemValueBJ(killingOwner, thistype.m_leaderboard, thistype.m_playerScore[GetPlayerId(killingOwner)])
			call LeaderboardSortItemsByValue(thistype.m_leaderboard, false)
			set killingUnit = null
			set killingOwner = null
		endmethod

		private static method createScoreTrigger takes nothing returns nothing
			set thistype.m_scoreTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(thistype.m_scoreTrigger, EVENT_PLAYER_UNIT_DEATH)
			call TriggerAddCondition(thistype.m_scoreTrigger, Condition(function thistype.triggerConditionScore))
			call TriggerAddAction(thistype.m_scoreTrigger, function thistype.triggerActionScore)
		endmethod

		private static method initStartUnits takes nothing returns nothing
			//haldars camp
			//baldars camp
			//call SetUnitOwner(gg_unit_h00B_0200, thistype.m_baldarsUser, true)
			call SetUnitOwner(gg_unit_h00B_0005, thistype.m_baldarsUser, true)
			call SetUnitOwner(gg_unit_h00B_0023, thistype.m_baldarsUser, true)
			call SetUnitOwner(gg_unit_h00B_0024, thistype.m_baldarsUser, true)
			call SetUnitOwner(gg_unit_h00B_0025, thistype.m_baldarsUser, true)
			//call SetUnitOwner(gg_unit_u000_0010, thistype.m_baldarsUser, true) // Lager
			call SetUnitOwner(gg_unit_u001_0190, thistype.m_baldarsUser, true) // worker
			call SetUnitOwner(gg_unit_u001_0191, thistype.m_baldarsUser, true) // worker
			call SetUnitOwner(gg_unit_u001_0192, thistype.m_baldarsUser, true) // worker
			call SetUnitOwner(gg_unit_n00F_0018, thistype.m_baldarsUser, true) // Quelle
			call SetUnitInvulnerable(gg_unit_n00J_0021, true)
		endmethod

		/**
		 * Initializes the whole AOS system. This must be called before using any methods.
		 * The system can be cleaned up using \ref cleanUp().
		 */
		public static method init takes nothing returns nothing
			local integer i
			local player user
			set thistype.m_haldarsUser = MapData.haldarPlayer // don't use neutral victim since units will return like creeps!
			set thistype.m_baldarsUser = MapData.baldarPlayer
			set thistype.m_haldarMembers = 0
			set thistype.m_baldarMembers = 0
			set thistype.m_characterHasEntered = false
			call SetPlayerFlagBJ(PLAYER_STATE_GIVES_BOUNTY, true, thistype.m_haldarsUser)
			call SetPlayerFlagBJ(PLAYER_STATE_GIVES_BOUNTY, true, thistype.m_baldarsUser)
			call SetPlayerAllianceStateBJ(thistype.m_haldarsUser, thistype.m_baldarsUser, bj_ALLIANCE_UNALLIED)
			call SetPlayerAllianceStateBJ(thistype.m_baldarsUser, thistype.m_haldarsUser, bj_ALLIANCE_UNALLIED)
			set i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				set user = Player(i)
				call SetPlayerAllianceStateBJ(user, thistype.m_haldarsUser, bj_ALLIANCE_NEUTRAL)
				call SetPlayerAllianceStateBJ(user, thistype.m_baldarsUser, bj_ALLIANCE_NEUTRAL)
				call SetPlayerAllianceStateBJ(thistype.m_haldarsUser, user, bj_ALLIANCE_NEUTRAL)
				call SetPlayerAllianceStateBJ(thistype.m_baldarsUser, user, bj_ALLIANCE_NEUTRAL)
				set user = null
				set i = i + 1
			endloop
			
			call SetPlayerColor(thistype.m_haldarsUser, PLAYER_COLOR_LIGHT_GRAY)
			call SetPlayerColor(thistype.m_baldarsUser, ConvertPlayerColor(12)) // black

			call thistype.createLeaderboard()
			call thistype.createEnterTrigger()
			call thistype.createLeaveTrigger()
			call thistype.createSpawnTimer()
			call thistype.createScoreTrigger()
			call thistype.initStartUnits()
		endmethod

		private static method destroyLeaderboard takes nothing returns nothing
			call DestroyLeaderboard(thistype.m_leaderboard)
			set thistype.m_leaderboard = null
		endmethod

		private static method destroyEnterTrigger takes nothing returns nothing
			call DestroyTrigger(thistype.m_enterTrigger)
			set thistype.m_enterTrigger = null
		endmethod

		private static method destroyLeaveTrigger takes nothing returns nothing
			call DestroyTrigger(thistype.m_leaveTrigger)
			set thistype.m_leaveTrigger = null
		endmethod

		private static method destroySpawnTimer takes nothing returns nothing
			call PauseTimerBJ(true, thistype.m_spawnTimer)
			call DestroyTimer(thistype.m_spawnTimer)
			set thistype.m_spawnTimer = null
		endmethod

		private static method destroyScoreTrigger takes nothing returns nothing
			call DestroyTrigger(thistype.m_scoreTrigger)
			set thistype.m_scoreTrigger = null
		endmethod

		private static method cleanUpStartUnits takes nothing returns nothing
			//haldars camp
			//baldars camp
			call SetUnitInvulnerable(gg_unit_n00J_0021, false)
		endmethod

		public static method cleanUp takes nothing returns nothing
			set thistype.m_haldarsUser = null
			set thistype.m_baldarsUser = null
			call thistype.destroyLeaderboard()
			call thistype.destroyEnterTrigger()
			call thistype.destroyLeaveTrigger()
			call thistype.destroySpawnTimer()
			call thistype.destroyScoreTrigger()
			call thistype.cleanUpStartUnits()
		endmethod

		// static members

		/**
		 * \return Returns the score in the AOS of a single player. The score is calculated by the last hits on enemies in the enemy AOS team.
		 */
		public static method playerScore takes player user returns integer
			return thistype.m_playerScore[GetPlayerId(user)]
		endmethod
	endstruct

endlibrary