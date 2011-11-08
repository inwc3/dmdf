library StructMapQuestsQuestSlaughter requires Asl, StructGameCharacter, StructMapMapFellows, StructMapMapNpcs, StructMapMapSpawnPoints, StructMapVideosVideoBloodthirstiness, StructMapVideosVideoDeathVault, StructMapVideosVideoDragonHunt

	struct QuestSlaughter extends AQuest
		private region m_newRegion
		private region m_enterRegion
		private trigger m_enterTrigger

		implement Quest

		public stub method distributeRewards takes nothing returns nothing
			local integer i
			local item whichItem
			/// \todo JassHelper bug
			//call AQuest.distributeRewards()
			/*
			Blutamulett
			Drachenschuppe
			2 große Heiltränke
			2 große Manatränke
			*/
			set i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (Character.playerCharacter(Player(i)) != 0) then
					call Character(Character.playerCharacter(Player(i))).giveItem('I02L')
					call Character(Character.playerCharacter(Player(i))).giveItem('I02M')
					call Character(Character.playerCharacter(Player(i))).giveItem('I00B')
					call Character(Character.playerCharacter(Player(i))).giveItem('I00B')
					call Character(Character.playerCharacter(Player(i))).giveItem('I00C')
					call Character(Character.playerCharacter(Player(i))).giveItem('I00C')
				endif
				set i = i + 1
			endloop

			call Character.displayItemAcquiredToAll(tr("STRING 4000"), tr("STRING 4001"))
			call Character.displayItemAcquiredToAll(tr("STRING 4003"), tr("STRING 4004"))
		endmethod

		private method stateEventNew takes trigger whichTrigger returns nothing
			call TriggerRegisterEnterRegion(whichTrigger, this.m_newRegion, null)
		endmethod

		private method stateConditionNew takes nothing returns boolean
			return Character.isUnitCharacter(GetTriggerUnit())
		endmethod

		private method stateActionNew takes nothing returns nothing
			call VideoDragonHunt.video().play()
			call waitForVideo(MapData.videoWaitInterval)
			call this.questItem(0).setState(thistype.stateNew)
			call this.displayState()
			call Fellows.dragonSlayer().shareWith(0)
			call TransmissionFromUnit(Npcs.dragonSlayer(), tr("In der Nähe befindet sich ein mächtiger Vampir, der über eine Hand voll Diener gebietet. Es wird Zeit, ihn abzuschlachten und dieses Land von einem weiteren Parasiten zu befreien!"), null)
		endmethod

		private static method stateEventCompleted takes AQuestItem questItem, trigger whichTrigger returns nothing
			call TriggerRegisterPlayerUnitEvent(whichTrigger, Player(PLAYER_NEUTRAL_AGGRESSIVE), EVENT_PLAYER_UNIT_DEATH, null)
		endmethod

		private static method stateConditionCompleted0 takes AQuestItem questItem returns boolean
			return GetUnitTypeId(GetTriggerUnit()) == UnitTypes.vampireLord and SpawnPoints.vampireLord0().countUnitsOfType(UnitTypes.vampireLord) == 0
		endmethod

		private static method stateActionCompleted0 takes AQuestItem questItem returns nothing
			call TransmissionFromUnit(Npcs.dragonSlayer(), tr("Gute Arbeit! Das war aber nicht der einzige Vampir in dieser Gegend. Weiter westlich befinden sich noch weitere seiner Art."), null)
			call thistype(questItem.quest()).setPingByUnitTypeId.execute(SpawnPoints.vampires0(), UnitTypes.vampire)
			call questItem.quest().questItem(1).enable()
		endmethod

		private static method stateConditionCompleted1 takes AQuestItem questItem returns boolean
			if (GetUnitTypeId(GetTriggerUnit()) == UnitTypes.vampire) then
				debug call Print("There are still " + I2S(SpawnPoints.vampires0().countUnitsOfType(UnitTypes.vampire)) + " vampires.")
				if (SpawnPoints.vampires0().countUnitsOfType(UnitTypes.vampire) == 0) then
					return true
				// get next one to ping
				else
					call thistype(questItem.quest()).setPingByUnitTypeId.execute(SpawnPoints.vampires0(), UnitTypes.vampire)
				endif
			endif
			return false
		endmethod

		private static method stateActionCompleted1 takes AQuestItem questItem returns nothing
			call TransmissionFromUnit(Npcs.dragonSlayer(), tr("Erst gestern beobachtete ich einen dunklen Engel des Todes, weiter östlich. Lasst ihn uns vernichten!"), null)
			call thistype(questItem.quest()).setPingByUnitTypeId.execute(SpawnPoints.deathAngel(), UnitTypes.deathAngel)
			call questItem.quest().questItem(2).enable()
		endmethod

		private method stateConditionCompleted2 takes AQuestItem questItem returns boolean
			return GetUnitTypeId(GetTriggerUnit()) == UnitTypes.deathAngel and SpawnPoints.deathAngel().countUnitsOfType(UnitTypes.deathAngel) == 0
		endmethod

		private static method stateActionCompleted2 takes AQuestItem questItem returns nothing
			call TransmissionFromUnit(Npcs.dragonSlayer(), tr("Einige untote Drachen haben sich weiter nördlich versammelt. Auf zum Kampf!"), null)
			call questItem.quest().questItem(3).enable()
		endmethod

		private static method stateConditionCompleted3 takes AQuestItem questItem returns boolean
			return GetUnitTypeId(GetTriggerUnit()) == UnitTypes.osseousDragon and SpawnPoints.boneDragons().countUnitsOfType(UnitTypes.boneDragon) == 0
		endmethod

		private method destroyEnterTrigger takes nothing returns nothing
			call RemoveRegion(this.m_enterRegion)
			set this.m_enterRegion = null
			call DmdfHashTable.global().destroyTrigger(this.m_enterTrigger)
			set this.m_enterTrigger = null
		endmethod

		private static method triggerConditionEnter takes nothing returns boolean
			return Character.isUnitCharacter(GetTriggerUnit())
		endmethod

		private static method triggerActionEnter takes nothing returns nothing
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			call this.destroyEnterTrigger()
			call VideoDeathVault.video().play()
		endmethod

		private method createEnterTrigger takes nothing returns nothing
			set this.m_enterRegion = CreateRegion()
			call RegionAddRect(this.m_enterRegion, null) /// \todo FIXME
			set this.m_enterTrigger = CreateTrigger()
			call TriggerRegisterEnterRegion(this.m_enterTrigger, this.m_enterRegion, null)
			call TriggerAddCondition(this.m_enterTrigger, Condition(function thistype.triggerConditionEnter))
			call TriggerAddAction(this.m_enterTrigger, function thistype.triggerActionEnter)
			call DmdfHashTable.global().setHandleInteger(this.m_enterTrigger, "this", this)
		endmethod

		private static method stateActionCompleted3 takes AQuestItem questItem returns nothing
			call TransmissionFromUnit(Npcs.dragonSlayer(), tr("Ausgezeichnet! In der Nähe befindet sich eine Höhle mit einer geheimen Gruft. Sie wird von Eingeweihten auch „die Todesgruft“ genannt."), null)
			call thistype(questItem.quest()).createEnterTrigger()
			call questItem.quest().questItem(4).enable()
		endmethod

		private static method stateConditionCompleted4 takes AQuestItem questItem returns boolean
			return GetUnitTypeId(GetTriggerUnit()) == UnitTypes.medusa and SpawnPoints.medusa().countUnitsOfType(UnitTypes.medusa) == 0
		endmethod

		private static method stateActionCompleted4 takes AQuestItem questItem returns nothing
			call TransmissionFromUnit(Npcs.dragonSlayer(), tr("Dieses Dreckschlangenvieh! Los, weiter, in die Gruft hinein!"), null)
		endmethod

		private static method stateConditionCompleted5 takes AQuestItem questItem returns boolean
			return GetUnitTypeId(GetTriggerUnit()) == UnitTypes.deacon and SpawnPoints.deathVault().countUnitsOfType(UnitTypes.deacon) == 0
		endmethod

		private static method stateActionCompleted5 takes AQuestItem questItem returns nothing
			local thistype this = thistype(questItem.quest())
			if (this.m_enterTrigger != null) then
				call DisableTrigger(this.m_enterTrigger)
				call this.destroyEnterTrigger()
			endif
			call Fellows.dragonSlayer().reset()
			call VideoBloodthirstiness.video().play()
		endmethod

		/// Considers death units (spawn points) and continues searching for the first one with unit type id \p unitTypeId of spawn point \p spawnPoint with an 1 second interval.
		private method setPingByUnitTypeId takes ASpawnPoint spawnPoint, integer unitTypeId returns nothing
			local unit whichUnit = spawnPoint.firstUnitOfType(unitTypeId)
			if (whichUnit == null) then
				call this.setPing(false)
				call TriggerSleepAction(1.0)
				call this.setPingByUnitTypeId.execute(spawnPoint, unitTypeId) // continue searching
			else
				call this.setPing(true)
				call this.setPingUnit(whichUnit)
				call this.setPingColour(100.0, 100.0, 100.0)
			endif
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(0, tr("Metzelei"))
			local AQuestItem questItem
			call this.setIconPath("") /// @todo fixme
			call this.setDescription(tr("Die Drachentöterin verlangt von euch, sie auf ihrem Feldzug gegen die Kreaturen des Waldes zu begleiten, um anderen von ihren Heldentaten zu berichten."))
			call this.setReward(AAbstractQuest.rewardExperience, 1000)
			set this.m_newRegion = CreateRegion()
			call RegionAddRect(this.m_newRegion, gg_rct_quest_slaughter_enable)
			call this.setStateEvent(thistype.stateNew, thistype.stateEventNew)
			call this.setStateCondition(thistype.stateNew, thistype.stateConditionNew)
			call this.setStateAction(thistype.stateNew, thistype.stateActionNew)

			set questItem = AQuestItem.create(this, tr("Tötet den Vampirgebieter."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompleted)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompleted0)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted0)

			call this.setPingByUnitTypeId.execute(SpawnPoints.vampireLord0(), UnitTypes.vampireLord)

			set questItem = AQuestItem.create(this, tr("Tötet die Vampire."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompleted)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompleted1)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted1)

			set questItem = AQuestItem.create(this, tr("Tötet den Todesengel."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompleted)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompleted2)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted2)

			set questItem = AQuestItem.create(this, tr("Tötet die Knochendrachen."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompleted)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompleted3)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted3)

			set questItem = AQuestItem.create(this, tr("Tötet die Medusa."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompleted)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompleted4)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted4)

			set questItem = AQuestItem.create(this, tr("Tötet den Diakon der Finsternis."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompleted)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompleted5)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted5)

			return this
		endmethod
	endstruct

endlibrary