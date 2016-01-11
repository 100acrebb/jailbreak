local triviaquestions  = {
	{"How many major-league baseball teams are there?","30"},
	{"The act of plucking, rather than bowing, violin strings, is known by what Italian word?","Pizzicato"},
	{"Absolute zero registers at how many degrees Celsius?","-273"},
	{"What is the tallest mountain in Colorado?","ELBERT"},
	{"What beer is marketed as The king of beers?","Budweiser"},
{"What name is given to a female swan?","Pen"},
{"Name the frontman of the Kaiser Chiefs who replaced Danny O'Donoghue as judge and mentor on 'The Voice UK'?","Ricky Wilson"},
{"Which is the world's second largest French-speaking city?","Montreal"},
{"What angle is formed by the hands of a clock at 4 o'clock?","120"},
{"England's national rugby union side play their home games at which ground?","Twickenham"},
{"In what year was Margaret Thatcher first elected Prime Minister?","1979"},
{"Which 1851 novel was first published in Britain under the title The Whale?","Moby Dick"},
{"How many toes does a dog have?","18"},
{"Where would you find the Sea of Tranquillity?","Moon"},
{"In the music video for The Pogues 'Fairytale of New York', which famous American actor born on February 18, 1964 plays the police officer who arrests Shane McGowan?","Matt Dillon"},
{"What was the first country to win the World Cup twice?","Italy"},
{"Who was born Leslie Townes Hope?","Bob Hope"},
{"In what television show would you find The Woolpack?","Emmerdale"},
{"What colour would Coca Cola be if you were to remove the artificial colouring?","Green"},
{"How many legs do butterflies have?","6"},
{"Which British prime minister was awarded the Nobel Prize for Literature?","Churchill"},
{"How is the number 5 written in Roman numerals?","V"},
{"Which is the only country to lie entirely within the Alps?","Liechtenstein"},
{"In Bingo, what number is referred to as ‘Doctor’s Orders’?","9"},
{"Which city was the capital of Australia from 1901 to 1927?","Melbourne"},
{"Which three-digit number refers to the NOT FOUND error message indicating that a HTTP server cannot find the requested item?","404"},
{"In American football, how many points is a touchdown worth?","6"},
{"What international news magazine became an online published magazine only in January 2013?","Newsweek"},
{"Hushabye Mountain featured in which musical film?","Chitty Chitty Bang Bang"},
{"Who painted the ceiling of the Sistine Chapel?","Michelangelo"},
{"What Tarantino movie won the Best Picture or prestigious Palme d'Or at the Cannes Film Festival in 1994?","Pulp Fiction"},
{"What is a baby seal called?","Pup"},
{"In Darts, how much is the Outer Bull worth?","25"},
{"What is the surname of the singer Rihanna born February 20, 1988?","Fenty"},
{"How many keys on a standard piano?","88"},
{"What colour to do you get when you mix red and white?","Pink"},
{"What is Pakistan's currency?","Rupee"},
{"Who were the backing group for Bill Hailey?","Comets"},
{"Which capital city lies on the Potomac River?","Washington"},
{"Whom did former Beatle star Paul McCartney wed in 2011?","Nancy Shevell"},
{"The pot-bellied pig is a breed of domesticated pig originating in which Asian country?","Vietnam"},
{"What is the square root of 16?","4"},
{"In what country are Pikeur cigars made?","Holland"},
{"What is the capital of Nepal?","Kathmandu"},
{"How many dots are there in total on a pair of dice?","42"},
{"At which ski resort was Michael Schumacher seriously injured during late 2013?","Meribel"}

}



local question,answer;

_RTN_RUNSTRING_JB_LR_TRIVIA_QUESTION = 0;

local winner_found = false;
local LR = JB.CLASS_LR();
LR:SetName("Trivia");
LR:SetDescription("After the countdown, a random question about a random subject will be asked. The first person to answer this question correctly in chat will win the last request, the loser will be killed.");
LR:SetStartCallback(function(prisoner,guard)

	
	--[[local url = "http://api.soundcloud.com/resolve.json?url="..rawURL.."&client_id=92373aa73cab62ccf53121163bb1246e"
    http.Fetch(url,
      function(body, len, headers, code)
          entry = util.JSONToTable(body)
          if !entry.streamable then
              cl_PPlay.showNotify( "SoundCloud URL not streamable", "error", 10)
              return
          end
          -- here we know entry is good, so invoke our post process function and
          -- give it the data we've fetched
          cb(entry);
      end,
      function( error )
          print("ERROR with fetching!")
      end
    );]]
	
	
	local qa = triviaquestions[math.random(1,#triviaquestions)]
	question = qa[1]
	answer = qa[2]
	
	winner_found = false;

	net.Start("JB.LR.Trivia.SendQuestion");
	net.WriteString(question);
	net.Broadcast();
end) 

LR:SetSetupCallback(function(prisoner,guard)
	net.Start("JB.LR.Trivia.SendPrepare");
	net.WriteEntity(prisoner);
	net.WriteEntity(guard);
	net.Broadcast();

	return false; // don't halt setup
end)

LR:SetIcon(Material("icon16/rosette.png"))

local id = LR();

if SERVER then
	util.AddNetworkString("JB.LR.Trivia.SendQuestion");
	util.AddNetworkString("JB.LR.Trivia.SendPrepare");
	util.AddNetworkString("JB.LR.Trivia.SendWinner");

	hook.Add( "PlayerSay", "JB.PlayerSay.LR.Trivia", function( ply, text, team )
		if JB.LastRequest == id and table.HasValue(JB.LastRequestPlayers,ply) and string.find(string.lower(text),string.lower(answer)) and not winner_found then
			timer.Simple(0,function()
				net.Start("JB.LR.Trivia.SendWinner");
				net.WriteEntity(ply);
				net.Broadcast();
			end);

			for k,v in ipairs(JB.LastRequestPlayers)do
				if IsValid(v) and v != ply then
					v:Kill();
				end
			end
			winner_found = true;
		end
	end )
elseif CLIENT then
	hook.Add("PlayerBindPress", "JB.PlayerBindPress.LR.TriviaNoSayBindsFuckYou", function(pl, bind, pressed) // Not the safest way, but it requires the least amount of touching code outside of this file (without using nasty hacky methods)
		if JB.LastRequest == id and table.HasValue(JB.LastRequestPlayers,pl) and string.find( bind,"say" ) then
			return true;
		end
	end)

	net.Receive("JB.LR.Trivia.SendPrepare",function()
		local guard,prisoner = net.ReadEntity(),net.ReadEntity();

		if not JB.Util.isValid(guard,prisoner) then return end

		chat.AddText( JB.Color["#bbb"], "Quizmaster", JB.Color.white, ": Hello ", guard, JB.Color.white, " and ", prisoner, JB.Color.white, ", prepare to give your answer via chat." );
		timer.Simple(2,function()
			chat.AddText( JB.Color["#bbb"], "Quizmaster", JB.Color.white, ": The first person to answer correctly will win this game of Trivia." );
		end);
	end);
	net.Receive("JB.LR.Trivia.SendQuestion",function()
		local question = net.ReadString() or "ERROR";
		chat.AddText( JB.Color["#bbb"], "Quizmaster", JB.Color.white, ": "..question );
	end);
	net.Receive("JB.LR.Trivia.SendWinner",function()
		local winner = net.ReadEntity();

		if not IsValid(winner) then return end

		chat.AddText( JB.Color["#bbb"], "Quizmaster", JB.Color.white, ": That is correct! ", winner, JB.Color.white, " wins." );
	end);	
end