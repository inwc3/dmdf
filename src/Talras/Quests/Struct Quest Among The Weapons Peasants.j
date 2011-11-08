library StructMapQuestsQuestAmongTheWeaponsPeasants requires Asl

	struct QuestAmongTheWeaponsPeasants extends AQuest

		implement CharacterQuest

		public stub method enable takes nothing returns boolean
			return super.enable()
		endmethod

		private static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character, tr("Zu den Waffen, Bauern!"))
			local AQuestItem questItem0
			local AQuestItem questItem1
			call this.setIconPath("") /// @todo fixme
			call this.setDescription(tr("Der Bauer Manfred beschwert sich darüber, dass der Herzog keine Wachen zu seinem Hof schickt, die diesen im Falle eines Angriffs beschützen könnten. Außerdem beklagt er sich über den von ihm und seinen Leuten geforderten einjährigen Kriegsdienst."))
			call this.setReward(AAbstractQuest.rewardExperience, 500)
			call this.setReward(AAbstractQuest.rewardGold, 300)
			// item 0
			set questItem0 = AQuestItem.create(this, tr("Sprich mit Manfred, dem Bauern."))
			call questItem0.setPing(true)
			call questItem0.setPingUnit(gg_unit_n01H_0148)
			call questItem0.setPingColour(100.0, 100.0, 100.0)
			// item 1
			set questItem1 = AQuestItem.create(this, tr("Berichte Ferdinand von dem Gespräch."))
			call questItem1.setPing(true)
			call questItem1.setPingUnit(gg_unit_n01J_0154)
			call questItem1.setPingColour(100.0, 100.0, 100.0)
			return this
		endmethod
	endstruct

endlibrary