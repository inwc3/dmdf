/// Metamorphosis
library StructSpellsSpellMetamorphosis requires Asl, StructGameCharacter, StructGameGrimoire

	/**
	 * \brief Generic abstract spell for metamorphosis.
	 * 
	 * Uses \ref EVENT_UNIT_SPELL_CHANNEL to be executed before the unit is morphed to successfully store the inventory items.
	 * 
	 * Besides it uses \ref EVENT_UNIT_HERO_REVIVE_FINISH to unmorph the character when being revived unmorphed.
	 * 
	 * \note All morph spells need a short delay in which \ref Character#morph() can be called which stores spells and items safely!
	 */
	struct SpellMetamorphosis
		private Character m_character
		private integer m_ability
		private integer m_favoriteAbility
		private integer m_unitTypeId
		private string m_orderString
		private string m_unorderString
		private trigger m_channelTrigger
		private trigger m_revivalTrigger
		private boolean m_isMorphed
		
		public method character takes nothing returns Character
			return this.m_character
		endmethod
		
		public method ability takes nothing returns integer
			return this.m_ability
		endmethod
		
		public method setFavoriteAbility takes integer favoriteAbility returns nothing
			set this.m_favoriteAbility = favoriteAbility
		endmethod
		
		public method favoriteAbility takes nothing returns integer
			return this.m_favoriteAbility
		endmethod
		
		public method setUnitTypeId takes integer unitTypeId returns nothing
			set this.m_unitTypeId = unitTypeId
		endmethod
		
		public method unitTypeId takes nothing returns integer
			return this.m_unitTypeId
		endmethod
		
		public method setOrderString takes string orderString returns nothing
			set this.m_orderString = orderString
		endmethod
		
		public method orderString takes nothing returns string
			return this.m_orderString
		endmethod
		
		public method setUnorderString takes string unorderString returns nothing
			set this.m_unorderString = unorderString
		endmethod
		
		public method unorderString takes nothing returns string
			return this.m_unorderString
		endmethod
		
		public method isMorphed takes nothing returns boolean
			return this.m_isMorphed
		endmethod
		
		// Called with .evaluate()
		public stub method canMorph takes nothing returns boolean
			return true
		endmethod
		
		/// Called after unit has morphed.
		public stub method onMorph takes nothing returns nothing
		endmethod
		
		// Called with .evaluate()
		public stub method canRestore takes nothing returns boolean
			return true
		endmethod
		
		/// Called after unit has been restored.
		public stub method onRestore takes nothing returns nothing
		endmethod
		
		public static method waitForRestoration takes unit whichUnit, integer unitTypeId returns nothing
			loop
				debug call Print("Checking if unit is no more: " + GetObjectName(unitTypeId) + ": " + I2S(unitTypeId))
				exitwhen (GetUnitTypeId(whichUnit) != unitTypeId)
				call TriggerSleepAction(1.0)
			endloop
		endmethod
		
		public static method waitForMorph takes unit whichUnit, integer unitTypeId returns nothing
			loop
				exitwhen (GetUnitTypeId(whichUnit) == unitTypeId)
				call TriggerSleepAction(1.0)
			endloop
		endmethod
		
		private static method triggerConditionStart takes nothing returns boolean
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			local boolean result =  GetSpellAbilityId() != null and GetSpellAbilityId() == this.ability() and GetTriggerUnit() == this.character().unit()
			debug call Print("Condition start for spell: " + GetAbilityName(this.ability()) + " with casted spell " + GetAbilityName(GetSpellAbilityId()) + " and caster " + GetUnitName(GetTriggerUnit()))
			debug if (GetSpellAbilityId() == null) then
			debug call Print("Spell is null")
			debug endif
			debug if (result) then
			debug call Print("Success")
			debug else
			debug call Print("Fail")
			debug endif
			return result
		endmethod
		
		private static method triggerActionStart takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			local boolean result = false
			call DisableTrigger(this.m_channelTrigger)
			call IssueImmediateOrder(this.character().unit(), "stop") // stop spell immediately
			debug call Print("Start for spell: " + GetObjectName(this.ability()))
			// morph
			if (not Character(this.character()).isMorphed()) then
				debug call Print("Is not morphed")
				if (this.canMorph.evaluate()) then
					debug call Print("Can morph")
					
					/*
					 * Now store everything before casting the ability.
					 */
					if (Character(this.character()).morph(this.ability())) then
						debug if (GetUnitTypeId(this.character().unit()) == this.unitTypeId()) then
							debug call Print("Error: Already morphed!")
						debug endif
						debug call Print("Morphed successfully for spell: " + GetObjectName(this.ability()))
						
						// prevent crashes when the morphing ability is removed for example by removing the casting item or grimoire abilities
						// do this before disabling inventory and removing the items
						/*
						*  The ability is removed then made permanent and casted again that it will not be losed by the metamorphosis.
						*/
						// make sure that the ability is not in the spell book
						debug call Print("Removing ability " + GetAbilityName(this.ability()))
						set result = UnitRemoveAbility(this.character().unit(), this.ability())
						debug if (result) then
						debug call Print("Successfully removed: " + GetAbilityName(this.ability()))
						debug else
						debug call Print("Unable to remove: " + GetAbilityName(this.ability()))
						debug endif
						debug call Print("Removing favorite ability " + GetAbilityName(this.favoriteAbility()))
						set result = UnitRemoveAbility(this.character().unit(), this.favoriteAbility())
						debug if (result) then
						debug call Print("Successfully removed favorite: " + GetAbilityName(this.favoriteAbility()))
						debug else
						debug call Print("Unable to remove favorite: " + GetAbilityName(this.favoriteAbility()))
						debug endif
						debug call Print("Adding morph ability to prevent crash: " + GetAbilityName(this.ability()))
						
						call Character(this.character()).grimoire().removeAllSpellsFromUnit()
						
						set result = UnitAddAbility(this.character().unit(), this.ability())
						debug if (result) then
						debug call Print("Successfully added: " + GetAbilityName(this.ability()))
						debug else
						debug call Print("Unable to add: " + GetAbilityName(this.ability()))
						debug endif
						set result = UnitMakeAbilityPermanent(this.character().unit(), true, this.ability())
						debug if (result) then
						debug call Print("Successfully made permanent: " + GetAbilityName(this.ability()))
						debug else
						debug call Print("Unable to make permanent: " + GetAbilityName(this.ability()))
						debug endif
			
						/*
						 * Use the corresponding order string.
						 */
						// TODO Crashes game!
						if (IssueImmediateOrder(this.character().unit(), this.orderString())) then
							debug call Print("Successful morph with spell: " + GetAbilityName(this.ability()))
							// morph spells are expected to morph immediately
							//call this.onMorph.execute()
						else
							debug call Print("Error on calling order " + this.orderString())
						endif
					else
						debug call Print("Error on morphing.")
					endif
					
					// sleep before enabling again otherwise the event will be raised again after morphing -> endless loop
					call TriggerSleepAction(100.0) // TODO wait spell duration + 0.10
					debug call Print("Enabling trigger")
					
				debug else
					debug call Print("Cannot morph for spell: " + GetObjectName(this.ability()))
				endif
			// restore
			else
				/*
				if (this.canRestore.evaluate()) then
					debug call Print("Restoring from metamorphosis with ability " + GetAbilityName(this.ability()))
					if (IssueImmediateOrder(this.character().unit(), this.unorderString())) then
						debug call Print("Waiting for restoration")
						call thistype.waitForRestoration(this.character().unit(), this.unitTypeId())
						debug call Print("Restore from morph with spell: "  + GetAbilityName(this.ability()))
						if (Character(this.character()).restoreUnit(this.ability())) then
							debug call Print("Restored successfully for spell: " + GetObjectName(this.ability()))
							set this.m_isMorphed = false
							call this.onRestore.execute()
						endif
					debug else
						debug call Print("Error on calling unorder " + this.unorderString())
					endif
				debug else
					debug call Print("Cannot restore for spell: " + GetObjectName(this.ability()))
					
				endif
				*/
			endif
			
			call EnableTrigger(this.m_channelTrigger)
		endmethod
		
		private static method triggerConditionRevival takes nothing returns boolean
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			debug call Print("Revival: " + GetAbilityName(this.ability()))
			debug if (this.isMorphed()) then
			debug call Print("Is morphed")
			debug endif
			return this.isMorphed()
		endmethod
		
		public static method create takes Character character, integer abilityId returns thistype
			local thistype this = thistype.allocate()
			set this.m_character = character
			set this.m_favoriteAbility = 0
			set this.m_ability = abilityId
			set this.m_unitTypeId = 0
			
			set this.m_channelTrigger = CreateTrigger()
			// register action before cast has finished!
			call TriggerRegisterUnitEvent(this.m_channelTrigger, this.character().unit(), EVENT_UNIT_SPELL_CHANNEL)
			call TriggerAddCondition(this.m_channelTrigger, Condition(function thistype.triggerConditionStart))
			call TriggerAddAction(this.m_channelTrigger, function thistype.triggerActionStart)
			call AHashTable.global().setHandleInteger(this.m_channelTrigger, "this", this)
			
			// unmorph unit if it is being revived and has been morphed
			set this.m_revivalTrigger = CreateTrigger()
			call TriggerRegisterUnitEvent(this.m_revivalTrigger, this.character().unit(), EVENT_UNIT_HERO_REVIVE_FINISH)
			call TriggerAddCondition(this.m_revivalTrigger, Condition(function thistype.triggerConditionRevival))
			call TriggerAddAction(this.m_revivalTrigger, function thistype.triggerActionStart)
			call AHashTable.global().setHandleInteger(this.m_revivalTrigger, "this", this)
			
			return this
		endmethod
		
		public method onDestroy takes nothing returns nothing
			call AHashTable.global().destroyTrigger(this.m_channelTrigger)
			set this.m_channelTrigger = null
			call AHashTable.global().destroyTrigger(this.m_revivalTrigger)
			set this.m_revivalTrigger = null
		endmethod
	endstruct

endlibrary