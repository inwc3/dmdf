library StructSpellsSpellReviveCreeps requires Asl, StructGameSpawnPoint

	struct SpellReviveCreeps
		private static trigger m_castTrigger

		private static method triggerCondition takes nothing returns boolean
			if (GetSpellAbilityId() == 'A1S8') then
				call Character.displayWarningToAll(tre("Die Unholde erwachen!", "The creeps are awakening!"))
				call SpawnPoint.spawnDeadOnlyAll()
			endif

			return false
		endmethod

		private static method onInit takes nothing returns nothing
			set thistype.m_castTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(thistype.m_castTrigger, EVENT_PLAYER_UNIT_SPELL_CAST)
			call TriggerAddCondition(thistype.m_castTrigger, Condition(function thistype.triggerCondition))
		endmethod
	endstruct

endlibrary