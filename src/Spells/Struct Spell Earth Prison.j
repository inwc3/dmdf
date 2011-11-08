/// Elemental Mage
library StructSpellsSpellEarthPrison requires Asl, StructGameClasses, StructGameSpell

	/**
	* Der Elementarmagier schließt einen Gegner bis zu X Sekunden in einem Erdgefängnis ein. In dieser Zeit kann er nicht agieren. Das Gefängnis entfernt alle negativen Effekte auf dem Ziel und wird durch Schaden gebrochen.
	*/
	struct SpellEarthPrison extends Spell
		public static constant integer abilityId = 'A01H'
		public static constant integer favouriteAbilityId = 'A03I'
		public static constant integer maxLevel = 5
		public static constant integer buffId = 'B005'
		private static constant real timeLevelValue = 2.0 // Zeit-Stufenfaktor (ab Stufe 1)

		private method action takes nothing returns nothing
			local unit target = GetSpellTargetUnit()
			local ADamageRecorder damageRecorder
			local real time = thistype.timeLevelValue
			call UnitRemoveBuffs(target, false, true)
			call PauseUnit(target, true)
			call UnitAddAbility(target, thistype.buffId)
			call UnitMakeAbilityPermanent(target, true, thistype.buffId)
			set damageRecorder = ADamageRecorder.create(target)
			loop
				exitwhen (time <= 0.0 or ASpell.enemyTargetLoopCondition(target) or damageRecorder.totalDamage() > 0.0)
				call TriggerSleepAction(1.0)
				set time = time - 1.0
			endloop
			call UnitRemoveAbility(target, thistype.buffId)
			call damageRecorder.destroy()
			call PauseUnit(target, false)
			set target = null
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, Classes.elementalMage(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
		endmethod
	endstruct

endlibrary