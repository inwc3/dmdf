library StructMapVideosVideoDeathVault requires Asl, StructGameGame

	struct VideoDeathVault extends AVideo
		private unit m_actorDragonSlayer
		private unit m_actorMedusa
		private unit m_actorDeacon
		private AGroup m_actorsDegenerateSouls
		private AGroup m_actorsRavenJugglers
		private AGroup m_actorsDoomedMen

		implement Video

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings()
			call SetTimeOfDay(0.0)
			//call PlayThematicMusic("Music\\TheDukeOfTalras.mp3")
			call CameraSetupApplyForceDuration(gg_cam_death_vault_0, true, 0.0)

			set this.m_actorDragonSlayer = thistype.unitActor(thistype.saveUnitActor(Npcs.dragonSlayer()))
			call SetUnitPositionRect(this.m_actorDragonSlayer, gg_rct_video_death_vault_dragon_slayer)
			call SetUnitFacing(this.m_actorDragonSlayer, 90.0)
			call ShowUnit(this.m_actorDragonSlayer, false)
			
			call SetUnitPositionRect(thistype.actor(), gg_rct_video_death_vault_actor)
			call SetUnitFacing(thistype.actor(), 90.0)
			call ShowUnit(thistype.actor(), false)
			
			set this.m_actorMedusa = thistype.unitActor(thistype.createUnitActorAtRect(Player(PLAYER_NEUTRAL_AGGRESSIVE), UnitTypes.medusa, gg_rct_video_death_vault_medusa, 0.0))
			/// \todo Create groups
			//private unit m_actorDeacon
			//private AGroup m_actorsDegenerateSouls
			//private AGroup m_actorsRavenJugglers
			//private AGroup m_actorsDoomedMen
			//doomedMan = 'n037'
			//public static constant integer deacon = 'n035'
			//public static constant integer ravenJuggler = 'n036'
			//public static constant integer degenerateSoul = 'n038'
		endmethod

		public stub method onPlayAction takes nothing returns nothing
			call TransmissionFromUnit(this.m_actorDragonSlayer, tr("In dieser Gruft befinden sich zwei starke böse Kreaturen. Zum Einen eine mächtige Medusa und zum Anderen der „Diakon der Finsternis“."), null)
			call CameraSetupApplyForceDuration(gg_cam_death_vault_1, true, 1.0)

			if (wait(0.50)) then
				return
			endif
			
			call CameraSetupApplyForceDuration(gg_cam_death_vault_2, true, 1.0)
			
			if (wait(0.50)) then
				return
			endif
			
			call CameraSetupApplyForceDuration(gg_cam_death_vault_3, true, 1.0)
			
			if (wait(0.50)) then
				return
			endif
			
			call CameraSetupApplyForceDuration(gg_cam_death_vault_4, true, 1.0)
			
			if (wait(0.50)) then
				return
			endif
			
			call CameraSetupApplyForceDuration(gg_cam_death_vault_5, true, 1.0)
			
			if (wait(0.50)) then
				return
			endif
			
			call CameraSetupApplyForceDuration(gg_cam_death_vault_6, true, 1.0)
			
			if (wait(0.50)) then
				return
			endif
			
			call CameraSetupApplyForceDuration(gg_cam_death_vault_7, true, 1.0)
			
			if (wait(0.50)) then
				return
			endif
			
			call CameraSetupApplyForceDuration(gg_cam_death_vault_8, true, 1.0)
			
			if (wait(0.50)) then
				return
			endif
			
			call CameraSetupApplyForceDuration(gg_cam_death_vault_9, true, 1.0)
			
			if (wait(0.50)) then
				return
			endif
			
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT, 1.50, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(2.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_death_vault_10, true, 0.0)
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN, 1.50, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(2.0)) then
				return
			endif
			
			call CameraSetupApplyForceDuration(gg_cam_death_vault_11, true, 1.0)
			
			if (wait(0.50)) then
				return
			endif
			
			call CameraSetupApplyForceDuration(gg_cam_death_vault_12, true, 1.0)
			
			if (wait(0.50)) then
				return
			endif
			
			call CameraSetupApplyForceDuration(gg_cam_death_vault_13, true, 1.0)
			
			if (wait(0.50)) then
				return
			endif
			
			call CameraSetupApplyForceDuration(gg_cam_death_vault_14, true, 1.0)
			
			if (wait(0.50)) then
				return
			endif
			
			call CameraSetupApplyForceDuration(gg_cam_death_vault_15, true, 1.0)
			
			if (wait(0.50)) then
				return
			endif
			
			call CameraSetupApplyForceDuration(gg_cam_death_vault_16, true, 1.0)
			
			if (wait(0.50)) then
				return
			endif
			
			call CameraSetupApplyForceDuration(gg_cam_death_vault_17, true, 1.0)
			
			if (wait(0.50)) then
				return
			endif
			
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT, 1.50, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(2.0)) then
				return
			endif
			/// \todo Start talking!
			call CameraSetupApplyForceDuration(gg_cam_death_vault_18, true, 0.0) // from behind
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN, 1.50, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(2.0)) then
				return
			endif
			
			call CameraSetupApplyForceDuration(gg_cam_death_vault_19, true, 0.0) // front
			call SetUnitAnimation(this.m_actorDeacon, "Spell")
			
			if (wait(2.0)) then
				return
			endif
			
			call CameraSetupApplyForceDuration(gg_cam_death_vault_19, true, 0.0) // start ritual
			call SetUnitAnimation(this.m_actorDeacon, "Spell Slam")
			call CameraSetupApplyForceDuration(gg_cam_death_vault_ritual, true, 3.0)
			
			if (wait(2.50)) then
				return
			endif
			
			/// \todo Create effect
			//gg_rct_video_death_vault_ritual
			
			if (wait(2.0)) then
				return
			endif
			
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT, 1.50, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(2.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_death_vault_entering, true, 0.0)
			call ShowUnit(this.m_actorDragonSlayer, true)
			call ShowUnit(thistype.actor(), true)
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN, 1.50, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(2.0)) then
				return
			endif
			
			call TransmissionFromUnit(this.m_actorDragonSlayer, tr("Nun aber auf in die Schlacht. Lasst keinen am Leben, hackt alle in Stücke und lasst uns für Ruhm und Ehre sterben!"), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call IssueRectOrder(this.m_actorDragonSlayer, "move", gg_rct_video_death_vault_target)
			call IssueRectOrder(thistype.actor(), "move", gg_rct_video_death_vault_target)
			
			if (wait(4.0)) then
				return
			endif

			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			call Game.resetVideoSettings()
		endmethod

		private static method create takes nothing returns thistype
			return thistype.allocate()
		endmethod
	endstruct

endlibrary