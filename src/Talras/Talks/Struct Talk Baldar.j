library StructMapTalksTalkBaldar requires Asl, StructGameCharacter, StructGameClasses, StructMapMapNpcs, StructMapQuestsQuestDeathToWhiteLegion

	struct TalkBaldar extends ATalk
		private boolean array m_gotOffer[6] /// \todo \ref MapData#maxPlayers
		private integer array m_lastRewardScore[6] /// \todo \ref MapData#maxPlayers

		implement Talk

		public method giveOffer takes nothing returns nothing
			local player user = this.character().player()
			set this.m_gotOffer[GetPlayerId(user)] = true
			set user = null
		endmethod

		/// Parameter is required since it's used by \ref TalkHaldar.
		public method gotOffer takes Character character returns boolean
			local player user = character.player()
			local boolean result = this.m_gotOffer[GetPlayerId(user)]
			set user = null
			return result
		endmethod

		private method startPageAction takes nothing returns nothing
			call this.showUntil(3)
		endmethod

		// Hallo.
		private static method infoAction0 takes AInfo info returns nothing
			call speech(info, false, tr("Hallo."), null)
			call speech(info, true, tr("Wer bist du und was machst du in meinem Lager?"), null)
			// (Charakter kennt noch keinen der beiden Brüder)
			if (not TalkHaldar.talk().infoHasBeenShownToCharacter(0, info.talk().character())) then
				call speech(info, false, tr("Dein Lager?"), null)
				call speech(info, true, tr("Ja, mein Lager!"), null)
				call speech(info, true, tr("Das ist das Lager der schwarzen Legion, meines Heers."), null)
				call info.talk().showRange(4, 5)
			// (Charakter hat bereits Haldar getroffen)
			else
				call speech(info, false, tr("Bist du Haldars Bruder?"), null)
				call speech(info, true, tr("Woher weißt du das?"), null)
				call speech(info, false, tr("Hab mit ihm gesprochen."), null)
				call speech(info, true, tr("Du wagst es, mit diesem Feigling zu sprechen? Wie kannst du dir das nur antun?"), null)
				call speech(info, false, tr("Ganz ruhig, Flügelmann."), null)
				call speech(info, true, tr("Weißt du eigentlich wen du vor dir hast? Ich bin Baldar, der mächtige Erzdämon aus …"), null)
				call speech(info, false, tr("… einem Kartoffelsack."), null)
				call speech(info, true, tr("Schweig, du Hund!"), null)
				// (Auftrag „Tod der schwarzen Legion“ nicht aktiv)
				if (QuestDeathToBlackLegion.characterQuest(info.talk().character()).isNotUsed()) then
					call speech(info, true, tr("Wenn du schon so eine spitze Zunge hast, dann verwende sie wenigstens gegen meinen Bruder!"), null)
					call speech(info, true, tr("Tritt meinem Heer bei und bekämpfe ihn und seinesgleichen!"), null)
					call speech(info, false, tr("Ich überleg's mir."), null)
					call speech(info, true, tr("Gut, aber nicht zu lange will ich hoffen."), null)
					call speech(info, false, tr("Gut Ding will Weile haben."), null)
					call thistype(info.talk()).giveOffer() // (Charakter erhält somit das Angebot)
				endif
				call info.talk().showStartPage()
			endif
		endmethod

		// (Charakter hat ein Angebot bekommen und der Auftrag „Tod der schwarzen Legion“ ist nicht aktiv)
		private static method infoCondition1 takes AInfo info returns boolean
			return thistype(info.talk()).gotOffer(info.talk().character()) and QuestDeathToBlackLegion.characterQuest(info.talk().character()).isNotUsed()
		endmethod

		// Ich möchte der schwarzen Legion beitreten.
		private static method infoAction1 takes AInfo info returns nothing
			local unit characterUnit = info.talk().character().unit()
			local item whichItem
			call speech(info, false, tr("Ich möchte der schwarzen Legion beitreten."), null)
			call speech(info, true, tr("Du hast es dir also nochmal gründlich überlegt, was?"), null)
			call speech(info, true, tr("Gut, zunächst einmal bekommst du diese Standarte hier. Es ist mein schwarzes Wappen, nicht so hässlich wie das weiße meines Bruders. Und damit du nicht das Gefühl hast, du müsstest hier umsonst kämpfen, hast du hier noch ein paar Goldmünzen und etwas Schwefel."), null)
			call speech(info, true, tr("So, jetzt erkläre ich dir mal, wie das hier läuft, auf dem „Schlachtfeld“. Es gibt zwei Wege, die die beiden Lager miteinander verbinden. Auf jedem dieser Wege schicken mein Bruder und ich Truppen gegeneinander los. Du kannst dir aussuchen, auf welchem der Wege du kämpfen möchtest. Das ist mir ziemlich egal, Hauptsache du kämpfst."), null)
			call speech(info, true, tr("Da gibt's nur ein kleines Problem. Mein Bruder und ich haben damals, als wir mit dem Kampf begonnen haben, ausgemacht, dass keiner außer uns beiden sich in den Streit einmischen darf. Die Krieger, die ich schicke, habe ich alle selbst erschaffen, das zählt also nicht als Einmischung."), null)
			call speech(info, true, tr("Du dagegen würdest gegen die Regeln verstoßen. Nicht, dass ich viel für Regeln übrig hätte, aber ich will nicht, dass mich mein verdammter Bruder einen Feigling nennt."), null)
			call speech(info, false, tr("Also, was soll ich tun?"), null)
			call speech(info, true, tr("Es gäbe da eine nette Lösung. Bevor du das Schlachtfeld betrittst, benutzt du einen Zauberring von mir, der dich in die Gestalt eines Dämons verwandelt."), null)
			call speech(info, false, tr("Aha."), null)
			call speech(info, true, tr("Keine Angst, sobald du ihn erneut wirken lässt, wirst du dich natürlich zurückverwandeln."), null)
			call speech(info, true, tr("Der Zauber wirkt allerdings nur innerhalb dieser Höhle. Außerhalb ist meine Aura nicht stark genug!"), null)
			call speech(info, true, tr("Ach so und noch etwas: Hast du genügend Krieger getötet, bekommst du natürlich auch entsprechende Belohnungen, die du dir bei mir persönlich abholen kannst."), null)
			call Character(info.talk().character()).giveQuestItem('I01B') // Standarte
			// Ring
			if (info.talk().character().class() == Classes.astralModifier()) then
				call Character(info.talk().character()).giveQuestItem('I015')
			/// @todo Add item types
			else
				debug call Print("Warnung: Unsupported class for ring.")
				call Character(info.talk().character()).giveQuestItem('I015')
			endif
			call QuestDeathToWhiteLegion.characterQuest(info.talk().character()).enable()
			call info.talk().showStartPage()
			set characterUnit = null
			set whichItem = null
		endmethod

		// (Auftrag „Tod der weißen Legion“ ist aktiv)
		private static method infoCondition2 takes AInfo info returns boolean
			return QuestDeathToWhiteLegion.characterQuest(info.talk().character()).isNew()
		endmethod

		// Gib mir meine Belohnung!
		private static method infoAction2 takes AInfo info returns nothing
			local integer newScore = Aos.playerScore(info.talk().character().player()) - thistype(info.talk()).m_lastRewardScore[GetPlayerId(info.talk().character().player())]
			local integer i
			call speech(info, false, tr("Gib mir meine Belohnung!"), null)
			// (Charakter hat mindestens zehn neue Tötungspunkte)
			if (newScore >= 10) then
				call speech(info, true, tr("Gut, hier hast du sie. Mach nur weiter so und wir werden meinen Bruder bald besiegt haben!"), null)
				// (Charakter erhält eine Belohnung)
				set newScore = newScore / 10
				set thistype(info.talk()).m_lastRewardScore[GetPlayerId(info.talk().character().player())] = thistype(info.talk()).m_lastRewardScore[GetPlayerId(info.talk().character().player())] + newScore * 10
				call QuestDeathToWhiteLegion.characterQuest(info.talk().character()).displayUpdateMessage(tr("Belohnung:"))
				set i = 0
				loop
					exitwhen (i == newScore)
					call QuestDeathToWhiteLegion.characterQuest(info.talk().character()).distributeRewards()
					set i = i + 1
				endloop
			// (Charakter hat weniger als zehn neue Tötungspunkte)
			else
				call speech(info, true, tr("Pah, töte erst mal mehr von seinen Leuten dann sehen wir weiter."), null)
			endif
			call info.talk().showStartPage()
		endmethod

		// Welches Heer?
		private static method infoAction0_0 takes AInfo info returns nothing
			call speech(info, false, tr("Welches Heer?"), null)
			call speech(info, true, tr("Bist du etwa blind? Schau dich doch mal um! Siehst du nicht die vielen Krieger? Sie alle dienen mir, um diesen Bastard Haldar zu vernichten!"), null)
			if (info.talk().showInfo(5)) then
				call info.talk().show()
			else
				call info.talk().showStartPage()
			endif
		endmethod

		// Schwarze Legion?
		private static method infoAction0_1 takes AInfo info returns nothing
			call speech(info, false, tr("Schwarze Legion?"), null)
			call speech(info, true, tr("Ja. So nennen wir uns, also mein Gefolge und ich. Wir kämpfen hier schon seit vielen Jahren gegen die weiße Legion. Sie wird von meinem widerlichen Bruder Haldar angeführt, einem Erzengel."), null)
			call info.talk().showRange(6, 8)
		endmethod

		// (Zurück)
		private static method infoAction0_2 takes AInfo info returns nothing
			call info.talk().showStartPage()
		endmethod

		// Wieso ist dein Bruder ein Erzengel?
		private static method infoAction0_1_0 takes AInfo info returns nothing
			call speech(info, false, tr("Wieso ist dein Bruder ein Erzengel?"), null)
			call speech(info, true, tr("Wieso sollte er es nicht sein, dieser Schweinehund?"), null)
			call speech(info, false, tr("Inzucht und so ..."), null)
			call speech(info, true, tr("Was sagst du? Sprich gefälligst lauter, wenn du mir was zu sagen hast."), null)
			call info.talk().showRange(7, 8)
		endmethod

		// Wieso kämpft ihr gegeneinander?
		private static method infoAction0_1_1 takes AInfo info returns nothing
			call speech(info, false, tr("Wieso kämpft ihr gegeneinander?"), null)
			call speech(info, true, tr("Spielt das eine Rolle für dich? Wieso fragst du überhaupt?"), null)
			call speech(info, false, tr("Reine Neugier."), null)
			call speech(info, true, tr("Hmm, na ja, also ehrlich gesagt, ich weiß es gar nicht mehr so genau. Aber das ändert nichts daran, dass mein Bruder ein mieser Lügner und Verräter ist und ich ihn vernichten werde!"), null)
			call info.talk().showInfo(6)
			call info.talk().showInfo(8)
			call info.talk().show()
		endmethod

		// Wer ist denn der Stärkere von euch beiden?
		private static method infoAction0_1_2 takes AInfo info returns nothing
			call speech(info, false, tr("Wer ist denn der Stärkere von euch beiden?"), null)
			call speech(info, true, tr("Ich natürlich. Versteht sich doch von selbst, dass ein Erzdämon stärker als ein Erzengel ist!"), null)
			call speech(info, true, tr("Wobei ich noch etwas Unterstützung gebrauchen könnte. Immerhin kämpfen wir nun schon so lange gegeneinander und keiner von uns beiden kann gewinnen. Schätze mal, er hat einfach zu viele Truppen um sich geschart, dieser feige Hund!"), null)
			call speech(info, true, tr("Du hättest nicht zufällig Lust, in mein Heer einzutreten?"), null)
			call thistype(info.talk()).giveOffer() // (Charakter erhält somit das Angebot)
			call info.talk().showRange(9, 10)
		endmethod

		// (Zurück)
		private static method infoAction0_1_3 takes AInfo info returns nothing
			if (info.talk().showInfo(4)) then
				call info.talk().show()
			else
				call info.talk().showStartPage()
			endif
		endmethod

		// Warum sollte ich?
		private static method infoAction0_1_2_0 takes AInfo info returns nothing
			call speech(info, false, tr("Warum sollte ich?"), null)
			call speech(info, true, tr("Weil du dann die Chance bekommst, einen Erzengel zu töten. Überleg's dir einfach mal."), null)
			call info.talk().showRange(6, 7)
		endmethod

		// Klar!
		private static method infoAction0_1_2_1 takes AInfo info returns nothing
			call speech(info, false, tr("Klar!"), null)
			call speech(info, true, tr("So so, ein tapferer Mann. Ich gebe dir noch etwas Zeit und wenn du's dir überlegt hast, dann melde dich einfach nochmal bei mir. Ich kann jeden Krieger gerbauchen."), null)
			call info.talk().showRange(6, 7)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.baldar(), thistype.startPageAction)
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				set this.m_gotOffer[i] = false
				set this.m_lastRewardScore[i] = 0
				set i = i + 1
			endloop

			// start page
			call this.addInfo(false, false, 0, thistype.infoAction0, tr("Hallo.")) //0
			call this.addInfo(false, false, thistype.infoCondition1, thistype.infoAction1, tr("Ich möchte der schwarzen Legion beitreten.")) //1
			call this.addInfo(true, false, thistype.infoCondition2, thistype.infoAction2, tr("Gib mir meine Belohnung!")) //2
			call this.addExitButton() //3

			// info 0
			call this.addInfo(false, false, 0, thistype.infoAction0_0, tr("Welches Heer?")) //4
			call this.addInfo(false, false, 0, thistype.infoAction0_1, tr("Schwarze Legion?")) //5
			// no back button since you have to talk about this!

			// info 0_1
			call this.addInfo(false, false, 0, thistype.infoAction0_1_0, tr("Wieso ist dein Bruder ein Erzengel?")) // 6
			call this.addInfo(false, false, 0, thistype.infoAction0_1_1, tr("Wieso kämpft ihr gegeneinander?")) // 7
			call this.addInfo(false, false, 0, thistype.infoAction0_1_2, tr("Wer ist denn der Stärkere von euch beiden?")) // 8
			// no back button since you have to talk about this!

			// info 0_1_1
			call this.addInfo(false, false, 0, thistype.infoAction0_1_2_0, tr("Warum sollte ich?")) // 9
			call this.addInfo(false, false, 0, thistype.infoAction0_1_2_1, tr("Klar!")) // 10

			return this
		endmethod
	endstruct

endlibrary