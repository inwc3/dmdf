library StructMapQuestsQuestSupplyForTalras requires Asl, StructGameCharacter, StructMapMapNpcs

	struct QuestSupplyForTalras extends AQuest

		implement CharacterQuest

		public stub method enable takes nothing returns boolean
			call this.setState(AAbstractQuest.stateNew)
			call this.questItem(0).setState(AAbstractQuest.stateNew)
			call this.questItem(4).setState(AAbstractQuest.stateNew)
			
			call this.displayState()
			
			return true
		endmethod
		
		private static method stateEventCompletedSupply0 takes AQuestItem questItem, trigger whichTrigger returns nothing
			call TriggerRegisterEnterRectSimple(whichTrigger, gg_rct_quest_supply_for_talras_supply_0)
		endmethod

		private static method stateConditionCompletedSupply0 takes AQuestItem questItem returns boolean
			return GetTriggerUnit() == questItem.character().unit()
		endmethod

		private static method stateActionCompletedSupply0 takes AQuestItem questItem returns nothing
			call Character(questItem.character()).giveQuestItem('I03S')
			call questItem.quest().displayUpdate()
		endmethod
		
		private static method stateEventCompletedSupply1 takes AQuestItem questItem, trigger whichTrigger returns nothing
			call TriggerRegisterEnterRectSimple(whichTrigger, gg_rct_quest_supply_for_talras_supply_1)
		endmethod

		private static method stateConditionCompletedSupply1 takes AQuestItem questItem returns boolean
			return GetTriggerUnit() == questItem.character().unit()
		endmethod

		private static method stateActionCompletedSupply1 takes AQuestItem questItem returns nothing
			call Character(questItem.character()).giveQuestItem('I03T')
			call questItem.quest().displayUpdate()
		endmethod
		
		private static method stateActionCompletedSendSupply takes AQuestItem questItem returns nothing
			local unit cart = CreateUnit(MapData.neutralPassivePlayer, 'h016', GetUnitX(Npcs.manfred()), GetUnitY(Npcs.manfred()), 0.0)
			call SetUnitInvulnerable(cart, true)
			call IssuePointOrder(cart, "move", GetRectCenterX(gg_rct_quest_supply_for_talras_cart_destination), GetRectCenterY(gg_rct_quest_supply_for_talras_cart_destination))
			set cart = null
		endmethod
		
		private static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character, tr("Die Versorgung von Talras"))
			local AQuestItem questItem

			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNMonsterLure.blp")
			call this.setDescription(tr("Markward, die rechte Hand des Herzogs, möchte sich auf eine bevorstehende Belagerung von Talras vorbereiten. Daher will er Vorräte vom Bauern Manfred in der Burg einlagern."))
			call this.setReward(thistype.rewardExperience, 500)
			call this.setReward(thistype.rewardGold, 300)
			// item 0
			set questItem = AQuestItem.create(this, tr("Veranlasse dass Manfred Vorräte nach Talras schickt."))
			call questItem.setPing(true)
			call questItem.setPingWidget(Npcs.manfred())
			call questItem.setPingColour(100.0, 100.0, 100.0)
			
			// item 1
			set questItem = AQuestItem.create(this, tr("Hole die Vorräte aus der Scheune."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompletedSupply0)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompletedSupply0)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompletedSupply0)
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_supply_for_talras_supply_0)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			
			// item 2
			set questItem = AQuestItem.create(this, tr("Hole die Vorräte von Guntrichs Mühle."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompletedSupply1)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompletedSupply1)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompletedSupply1)
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_supply_for_talras_supply_1)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			
			// item 3
			set questItem = AQuestItem.create(this, tr("Bringe die Vorräte zu Manfred."))
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompletedSendSupply)
			call questItem.setPing(true)
			call questItem.setPingWidget(Npcs.manfred())
			call questItem.setPingColour(100.0, 100.0, 100.0)

			// item 4
			set questItem = AQuestItem.create(this, tr("Berichte Markward davon."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.markward())
			call questItem.setPingColour(100.0, 100.0, 100.0)

			return this
		endmethod
	endstruct

endlibrary