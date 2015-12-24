/// Dragon Slayer
library StructSpellsSpellJumpAttackDragonSlayer requires Asl, StructGameClasses, StructGameSpell

	struct Knockback
		private Character m_source
		private unit m_target
		private real m_speed
		private real m_angle
		private real m_distance
		private real m_movedDistance
		
		public method source takes nothing returns Character
			return this.m_source
		endmethod
		
		public method target takes nothing returns unit
			return this.m_target
		endmethod
		
		public method speed takes nothing returns real
			return this.m_speed
		endmethod
		
		public method angle takes nothing returns real
			return this.m_angle
		endmethod
		
		public method distance takes nothing returns real
			return this.m_distance
		endmethod
		
		public method effect takes nothing returns nothing
			local real damage = GetUnitAbilityLevel(this.source().unit(), SpellJumpAttackDragonSlayer.abilityId) * 10
			call UnitDamageTargetBJ(this.source().unit(), this.target(), damage, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL)
			call Spell.showDamageTextTag(this.target(), damage)
			call SpellJumpAttackDragonSlayer.stunUnit.evaluate(this.target(), GetUnitAbilityLevel(this.source().unit(), SpellJumpAttackDragonSlayer.abilityId))
			// TODO stun
		endmethod
		
		public method increaseDistance takes real distance returns boolean
			set this.m_movedDistance = this.m_movedDistance + distance
			return this.m_movedDistance >= this.m_distance
		endmethod
		
		public static method create takes Character source, unit target, real speed, real angle, real distance returns thistype
			local thistype this = thistype.allocate()
			set this.m_source = source
			set this.m_target = target
			set this.m_speed = speed
			set this.m_angle = angle
			set this.m_distance = distance
			set this.m_movedDistance = 0.0
			
			return this
		endmethod
	endstruct

	/// Der Drachentöter nimmt Anlauf und wirft sich mit voller Wucht auf eine Gruppe von Gegnern. Dabei richtet er X Schaden bei jedem der Gegner an, stößt sie von sich und lähmt sie für Y Sekunden.
	struct SpellJumpAttackDragonSlayer extends Spell
		public static constant integer abilityId = 'A1GK'
		public static constant integer favouriteAbilityId = 'A1GL'
		public static constant integer classSelectionAbilityId = 'A1GM'
		public static constant integer classSelectionGrimoireAbilityId = 'A1GR'
		public static constant integer maxLevel = 5
		public static constant integer stunAbilityId = 'A1GW'
		public static constant integer dummyId = 'h02J'
		private static constant real period = 0.01
		private static unit m_dummy
		private static timer m_knockBackTimer
		private static boolean m_timerIsRunning = false
		private static AIntegerList m_knockBacks
		
		public static method stunUnit takes unit whichUnit, integer level returns nothing
			call SetUnitAbilityLevel(thistype.m_dummy, thistype.stunAbilityId, level)
			call IssueTargetOrder(thistype.m_dummy, "firebolt", whichUnit)
		endmethod
		
		private static method filterIsNotDead takes nothing returns boolean
			return not IsUnitDeadBJ(GetFilterUnit())
		endmethod
		
		private method targets takes real x, real y returns AGroup
			local AGroup result = AGroup.create()
			local integer i = 0
			call result.addUnitsInRange(x, y, 300.0, Filter(function thistype.filterIsNotDead))
			loop
				exitwhen (i == result.units().size())
				if (not IsUnitEnemy(result.units()[i], this.character().player())) then
					call result.units().erase(i)
				else
					set i = i + 1
				endif
			endloop
			
			return result
		endmethod
		
		private method condition takes nothing returns boolean
			local AGroup targets = this.targets(GetSpellTargetX(), GetSpellTargetY())
			local boolean result = true
			if (targets.units().empty()) then
				call this.character().displayMessage(ACharacter.messageTypeError, tr("Keine gültigen Ziele in Reichweite."))
				set result = false
			endif
			return result
		endmethod
		
		private static method alignAction takes unit usedUnit returns nothing
			local thistype this = DmdfHashTable.global().handleInteger(usedUnit, "SpellJumpAttackDragonSlayer")
			local AGroup targets = this.targets(GetUnitX(usedUnit), GetUnitY(usedUnit))
			local integer i = 0
			loop
				exitwhen (i == targets.units().size())
				call thistype.m_knockBacks.pushBack(Knockback.create(Character(this.character()), targets.units()[i], 50.0, GetAngleBetweenUnits(usedUnit, targets.units()[i]), 200.0))
				// TODO custom knockback and damage
				//call KnockbackTarget(usedUnit, targets.units()[i], GetAngleBetweenUnits(usedUnit, targets.units()[i]), 600.0, 20.0, true, true, false)
				set i = i + 1
			endloop
			call thistype.startTimer.evaluate()
			call SetUnitAnimation(usedUnit, "Attack Slam")
			call ResetUnitAnimation(usedUnit)
			call DmdfHashTable.global().flushKey("SpellJumpAttackDragonSlayer")
		endmethod

		private method action takes nothing returns nothing
			call DmdfHashTable.global().setHandleInteger(GetTriggerUnit(), "SpellJumpAttackDragonSlayer", this)
			call AJump.create(GetTriggerUnit(), 600.0, GetSpellTargetX(), GetSpellTargetY(), thistype.alignAction, 600.0)
			call SetUnitAnimation(GetTriggerUnit(), "Attack Slam")
		endmethod

		public static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character, Classes.dragonSlayer(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, thistype.condition, thistype.action)
			
			call this.addGrimoireEntry('A1GM', 'A1GR')
			call this.addGrimoireEntry('A1GN', 'A1GS')
			call this.addGrimoireEntry('A1GO', 'A1GT')
			call this.addGrimoireEntry('A1GP', 'A1GU')
			call this.addGrimoireEntry('A1GQ', 'A1GV')
			
			return this
		endmethod
		
		private static method timerFunctionKnockbacks takes nothing returns nothing
			local Knockback knockback = 0
			local location oldPos = null
			local location newPos = null
			local boolean finish = false
			local AIntegerListIterator iterator = thistype.m_knockBacks.begin()
			loop
				exitwhen (not iterator.isValid())
				set knockback = Knockback(iterator.data())
				call iterator.next()
				set finish = false
				set oldPos = Location(GetUnitX(knockback.target()), GetUnitY(knockback.target()))
				set newPos = PolarProjectionBJ(oldPos, thistype.period * knockback.speed(),  knockback.angle())
				
				if (IsTerrainWalkable(GetLocationX(newPos), GetLocationY(newPos), 80.0)) then
					call SetUnitPositionLoc(knockback.target(), newPos)
					if (knockback.increaseDistance(thistype.period * knockback.speed())) then
						set finish = true
					endif
				// stop at any blocker
				else
					set finish = true
				endif
				call RemoveLocation(oldPos)
				set oldPos = null
				call RemoveLocation(newPos)
				set newPos = null
				
				if (finish) then
					debug call Print("Destroy knockback: " + I2S(knockback))
					call knockback.effect()
					call thistype.m_knockBacks.remove(knockback)
					call knockback.destroy()
				endif
				
			endloop
			call iterator.destroy()
			
			if (thistype.m_knockBacks.empty()) then
				set thistype.m_timerIsRunning = false
				call PauseTimer(thistype.m_knockBackTimer)
			endif
		endmethod	
		
		private static method startTimer takes nothing returns nothing
			if (not thistype.m_timerIsRunning) then
				call TimerStart(thistype.m_knockBackTimer, thistype.period, true, function thistype.timerFunctionKnockbacks)
				set thistype.m_timerIsRunning = true
			endif
		endmethod
		
		private static method onInit takes nothing returns nothing
			set thistype.m_dummy = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), thistype.dummyId, 0.0, 0.0, 0.0)
			call SetUnitInvulnerable(thistype.m_dummy, true)
			call ShowUnit(thistype.m_dummy, false)
			set thistype.m_knockBackTimer = CreateTimer()
			set thistype.m_timerIsRunning = false
			set thistype.m_knockBacks = AIntegerList.create()
			call TriggerSleepAction(0.0)
			call thistype.startTimer()
		endmethod
	endstruct

endlibrary