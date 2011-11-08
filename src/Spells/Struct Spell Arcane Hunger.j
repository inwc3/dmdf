/// Wizard
library StructSpellsSpellArcaneHunger requires Asl, StructGameClasses, StructGameSpell

	/// Saugt X% Mana pro Sekunde jeweils von allen Gegnern im Umkreis von Y ab und überträgt es auf den Zauberer. Das Mana kann dabei nicht über das Mana-Maximum des Zauberers hinausgehen. Hält Z Sekunden. Prozentsatz, Umkreis und Dauer werden mit der Stufe erhöht.
	struct SpellArcaneHunger extends Spell
		public static constant integer abilityId = 'A05O'
		public static constant integer favouriteAbilityId = 'A05P'
		public static constant integer maxLevel = 5
		private static constant real rangeStartValue = 300.0
		private static constant real rangeLevelValue = 100.0
		private static constant real timeStartValue = 5.0
		private static constant real timeLevelValue = 2.0
		private static constant real manaStartPercentage = 6.0
		private static constant real manaLevelPercentage = 2.0

		private static method filter takes nothing returns boolean
			local unit filterUnit = GetFilterUnit()
			local boolean result = not IsUnitDeadBJ(filterUnit) and GetUnitState(filterUnit, UNIT_STATE_MAX_MANA) > 0
			set filterUnit = null
			return result
		endmethod
		
		private method range takes nothing returns real
			return thistype.rangeStartValue + this.level() * thistype.rangeLevelValue
		endmethod
		
		private method time takes nothing returns real
			return thistype.timeStartValue + this.level() * thistype.timeLevelValue
		endmethod
		
		private method manaPercentage takes nothing returns real
			return thistype.manaStartPercentage + this.level() * thistype.manaLevelPercentage
		endmethod
		
		private method condition takes nothing returns boolean
			local unit caster = this.character().unit()
			local group targetGroup = CreateGroup()
			local filterfunc filter = Filter(function thistype.filter)
			local AGroup targets = AGroup.create()
			local boolean result
			call GroupEnumUnitsInRange(targetGroup, GetUnitX(caster), GetUnitY(caster), this.range(), filter)
			debug call Print("Arcane Hunger: Adding units in range of " + R2S(this.range()) + ".")
			call targets.addGroup(targetGroup, true, false)
			call targets.removeAlliesOfUnit(caster)
			debug call Print("Arcane Hunger: After removing allies we still have " + I2S(targets.units().size()) + " targets left.")
			set targetGroup = null
			set result = not targets.units().empty()
			set caster = null
			call DestroyFilter(filter)
			set filter = null
			call targets.destroy()
			
			if (not result) then
				call this.character().displayMessage(ACharacter.messageTypeError, tr("Keine verwertbaren Gegner im Umkreis."))
			endif
			
			return result
		endmethod

		private method action takes nothing returns nothing
			local unit caster = this.character().unit()
			local group targetGroup = CreateGroup()
			local filterfunc filter = Filter(function thistype.filter)
			local AGroup targets = AGroup.create()
			local AIntegerVector dynamicLightnings
			local integer i
			local unit target
			local real time
			local real mana
			call GroupEnumUnitsInRange(targetGroup, GetUnitX(caster), GetUnitY(caster), this.range(), filter)
			call targets.addGroup(targetGroup, true, false)
			call targets.removeAlliesOfUnit(caster)
			set targetGroup = null
			// TODO checked already in condition if empty
			if (not targets.units().empty()) then
				set dynamicLightnings = AIntegerVector.create()
				set i = 0
				loop
					exitwhen (i == targets.units().size())
					set target = targets.units().at(i)
					debug call Print("Arcane Hunger: Target " + GetUnitName(target))
					call dynamicLightnings.pushBack(ADynamicLightning.create(null, "DRAM", 0.01, caster, target))
					set target = null
					set i = i + 1
				endloop

				set time = this.time()
				loop
					exitwhen (time <= 0.0 or targets.units().empty() or IsUnitDeadBJ(caster))
					call TriggerSleepAction(1.0)
					set i = 0
					loop
						exitwhen (i == targets.units().size())
						set target = targets.units()[i]
						if (ASpell.enemyTargetLoopCondition(target)) then
							call targets.units().erase(i)
							call ADynamicLightning(dynamicLightnings[i]).destroy()
							call dynamicLightnings.erase(i)
						else
							set mana = RMinBJ(GetUnitState(target, UNIT_STATE_MAX_MANA) * this.manaPercentage() / 100.0, GetUnitState(target, UNIT_STATE_MANA))
							if (mana > 0.0) then
								call SetUnitState(target, UNIT_STATE_MANA, GetUnitState(target, UNIT_STATE_MANA) - mana)
								call thistype.showManaCostTextTag(target, mana)
								call SetUnitState(caster, UNIT_STATE_MANA, GetUnitState(caster, UNIT_STATE_MANA) + mana)
							endif
							set i = i + 1
						endif
						set target = null
					endloop
					set time = time - 1.0
				endloop

				set i = 0
				loop
					exitwhen (i == dynamicLightnings.size())
					call ADynamicLightning(dynamicLightnings[i]).destroy()
					set i = i + 1
				endloop

				call dynamicLightnings.destroy()
			endif
		
			set caster = null
			call DestroyFilter(filter)
			set filter = null
			call targets.destroy()
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, Classes.wizard(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
		endmethod
	endstruct

endlibrary