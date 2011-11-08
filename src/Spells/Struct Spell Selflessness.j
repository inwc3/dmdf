/// Knight
library StructSpellsSpellSelflessness requires Asl, StructGameClasses, StructGameDmdfHashTable, StructGameSpell

	/// Der Ritter kann sich mit einem Verbündeten verbinden, und erleidet 15 Sekunden lang 160% dessen erlittenen Schadens. Der Verbündete erleidet während dieser Zeit 60% weniger Schaden. Der Effekt kann nicht unterbrochen werden. 5 Minuten Abklingzeit.
	struct SpellSelflessness extends Spell
		public static constant integer abilityId = 'A073'
		public static constant integer favouriteAbilityId = 'A074'
		public static constant integer maxLevel = 5
		private static constant integer casterBuffId = 'B014'
		private static constant integer targetBuffId = 'B013'
		private static constant integer time = 15 // 15 seconds
		private static constant real damageBonusFactor = 1.60
		private static constant real damageReductionStartValueFactor = 0.60
		private static constant real damageReductionLevelBonus = 0.10 // ab Stufe 2!
		private static ABuff casterBuff
		private static ABuff targetBuff

		/// @todo Create effect.
		private static method onCasterDamageAction takes ADamageRecorder damageRecorder returns nothing
			local real damage = GetEventDamage() * thistype.damageBonusFactor
			call SetUnitState(GetTriggerUnit(), UNIT_STATE_LIFE, GetUnitState(GetTriggerUnit(), UNIT_STATE_LIFE) - damage)
			call Spell.showLifeCostTextTag(GetTriggerUnit(), damage)
		endmethod

		/// @todo Create effect.
		private static method onTargetDamageAction takes ADamageRecorder damageRecorder returns nothing
			local integer level = Spell(DmdfHashTable.global().integer("SpellSelflessness", "TargetDamageRecorder" + I2S(damageRecorder) + "Spell")).level()
			local real damage = GetEventDamage() * (thistype.damageReductionStartValueFactor + (level - 1) * thistype.damageReductionLevelBonus)
			call SetUnitState(GetTriggerUnit(), UNIT_STATE_LIFE, GetUnitState(GetTriggerUnit(), UNIT_STATE_LIFE) + damage)
			call Spell.showDamageAbsorbationTextTag(GetTriggerUnit(), damage)
		endmethod

		/// @todo Create lightning.
		private method action takes nothing returns nothing
			local integer casterBuffIndex = thistype.casterBuff.add(GetTriggerUnit())
			local integer targetBuffIndex = thistype.targetBuff.add(GetSpellTargetUnit())
			local integer counter = 0
			local ADamageRecorder casterDamageRecorder = ADamageRecorder.create(GetTriggerUnit())
			local ADamageRecorder targetDamageRecorder = ADamageRecorder.create(GetSpellTargetUnit())
			call casterDamageRecorder.setSaveData(false)
			call casterDamageRecorder.setOnDamageAction(thistype.onCasterDamageAction)
			call targetDamageRecorder.setSaveData(false)
			call targetDamageRecorder.setOnDamageAction(thistype.onTargetDamageAction)
			call DmdfHashTable.global().setInteger("SpellSelflessness", "TargetDamageRecorder" + I2S(targetDamageRecorder) + "Spell", this)
			loop
				exitwhen (counter == thistype.time or not ASpell.allyTargetLoopCondition(GetSpellTargetUnit()) or not ASpell.allyTargetLoopCondition(GetTriggerUnit()))
				call TriggerSleepAction(1.0)
				set counter = counter + 1
			endloop
			call casterDamageRecorder.destroy()
			call DmdfHashTable.global().removeInteger("SpellSelflessness", "TargetDamageRecorder" + I2S(targetDamageRecorder) + "Spell")
			call targetDamageRecorder.destroy()
			call thistype.casterBuff.remove(GetTriggerUnit())
			call thistype.targetBuff.remove(GetSpellTargetUnit())
		endmethod

		public static method create takes Character character returns thistype
			if (thistype.casterBuff == 0) then
				set thistype.casterBuff = ABuff.create(thistype.casterBuffId)
			endif
			if (thistype.targetBuff == 0) then
				set thistype.targetBuff = ABuff.create(thistype.targetBuffId)
			endif
			return thistype.allocate(character, Classes.knight(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
		endmethod

		private static method onInit takes nothing returns nothing
			set thistype.casterBuff = 0
			set thistype.targetBuff = 0
		endmethod
	endstruct

endlibrary