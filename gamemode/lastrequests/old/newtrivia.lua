
if THABJBTrivia == nil then
	THABJBTrivia = {}
end

THABJBTrivia.Active = false
THABJBTrivia.CorrectAnswer = ""



--local question,answer,category;


_RTN_RUNSTRING_JB_LR_TRIVIA_QUESTION = 0;

local winner_found = false;
local LR = JB.CLASS_LR();
LR:SetName("New Trivia");
LR:SetDescription("After the countdown, a random question will be asked. The first person to answer this question correctly in chat will win the last request, the loser will be killed.");
LR:SetStartCallback(function(prisoner,guard)
	
	THABJBTrivia:SendAQuestion()
	
end) 

LR:SetSetupCallback(function(prisoner,guard)
	net.Start("THAB.LR.Trivia.SendPrepare");
	net.WriteEntity(prisoner);
	net.WriteEntity(guard);
	net.Broadcast();
	

	return false; // don't halt setup
end)

LR:SetIcon(Material("icon16/rosette.png"))

local id = LR();

if SERVER then
	util.AddNetworkString("THAB.LR.Trivia.SendQuestion");
	util.AddNetworkString("THAB.LR.Trivia.SendPrepare");
	util.AddNetworkString("THAB.LR.Trivia.SendWinner");

	hook.Add( "PlayerSay", "THAB.PlayerSay.LR.Trivia", function( ply, text, team )
	
		if (THABJBTrivia.Active == true and ply.HasAnswered == false) then
			if THABJBTrivia.CanAnswerMulti == false then
				ply.HasAnswered = true
			end
	
	
			if JB.LastRequest == id and table.HasValue(JB.LastRequestPlayers,ply) 
									and  (       (THABJBTrivia.AnswerExact == true and string.lower(text) == string.lower(THABJBTrivia.CorrectAnswer)) 
											  or (THABJBTrivia.AnswerExact == false and string.find(string.lower(text),string.lower(THABJBTrivia.CorrectAnswer)) )      )
									and not winner_found then
				THABJBTrivia:EndTrivia()
				timer.Simple(0,function()
					net.Start("THAB.LR.Trivia.SendWinner");
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
		end
	end )
elseif CLIENT then
	hook.Add("PlayerBindPress", "THAB.PlayerBindPress.LR.TriviaNoSayBindsFuckYou", function(pl, bind, pressed) // Not the safest way, but it requires the least amount of touching code outside of this file (without using nasty hacky methods)
		if JB.LastRequest == id and table.HasValue(JB.LastRequestPlayers,pl) and string.find( bind,"say" ) then
			return true;
		end
	end)

	net.Receive("THAB.LR.Trivia.SendPrepare",function()
		local guard,prisoner = net.ReadEntity(),net.ReadEntity();

		if not JB.Util.isValid(guard,prisoner) then return end

		chat.AddText( JB.Color["#bbb"], "Quizmaster", JB.Color.white, ": Hello ", guard, JB.Color.white, " and ", prisoner, JB.Color.white, ", prepare to give your answer via chat." );
		timer.Simple(2,function()
			chat.AddText( JB.Color["#bbb"], "Quizmaster", JB.Color.white, ": The first person to answer correctly will win this game of Trivia." );
		end);
	end);
	net.Receive("THAB.LR.Trivia.SendQuestion",function()
		local question = net.ReadString() or "ERROR";
		chat.AddText( JB.Color["#bbb"], "Quizmaster", JB.Color.white, ": "..question );
	end);
	net.Receive("THAB.LR.Trivia.SendWinner",function()
		local winner = net.ReadEntity();

		if not IsValid(winner) then return end

		chat.AddText( JB.Color["#bbb"], "Quizmaster", JB.Color.white, ": That is correct! ", winner, JB.Color.white, " wins." );
	end);	
end



--------------------------------------------------------------------
if SERVER then

function THABJBTrivia:SendAQuestion()

	winner_found = false;
	
	THABJBTrivia:ResetTrivia()

	local type =  math.random( 1, 2 )

	if (type < 2) then
		THABJBTrivia:AskNumberTrivia1()  
	elseif (type < 3) then
		THABJBTrivia:AskMultiTrivia1()
	elseif (type < 4) then
		THABJBTrivia:AskJeapordyTrivia1()
	end
	
end


function THABJBTrivia:ResetTrivia()
	for k, ply in pairs( player.GetAll() ) do
		ply.HasAnswered = false;
	end
end



function THABJBTrivia:AskMultiTrivia1()

	THABJBTrivia.Type = "multi"
	THABJBTrivia.Timeout = 20
	THABJBTrivia.ImmediateWin = true
	THABJBTrivia.AnswerExact = true
	THABJBTrivia.CanAnswerMulti = false
	category = ""

	local url = "https://pareshchouhan-trivia-v1.p.mashape.com/v1/getRandomQuestion?mashape-key=9wanCl0NINmshoeqeu8DRAuau3h0p1qGtv2jsnoI2MGedj3Eju"
    http.Fetch(url,
      function(body, len, headers, code)
          jtable = util.JSONToTable(body)
		  
		  local question = jtable.q_text
		  question = string.Replace(question, "&lt;div id=&quot;MathJax_Message&quot; style=&quot;display: none;&quot;&gt;&lt;/div&gt;", "")
		  question = string.Replace(question, "&lt;div style=&quot;display: none;&quot; id=&quot;MathJax_Message&quot;&gt;&lt;/div&gt;", "")
          
		  SendChatMsg(question)
		  SendChatMsg("1] ".. jtable.q_options_1)
		  SendChatMsg("2] ".. jtable.q_options_2)
		  SendChatMsg("3] ".. jtable.q_options_3)
		  SendChatMsg("4] ".. jtable.q_options_4)
		  
		  THABJBTrivia.CorrectAnswer = tostring(jtable.q_correct_option)
		  THABJBTrivia.Active = true
		  timer.Create( "THABJBTriviaTimer", THABJBTrivia.Timeout, 1, HandleJBTriviaTimer )

		  
      end,
      function( error )
          print("ERROR with fetching!")
      end
    );
end


function THABJBTrivia:AskNumberTrivia1()

	THABJBTrivia.Type = "answer"
	THABJBTrivia.Timeout = 20
	THABJBTrivia.ImmediateWin = true
	THABJBTrivia.AnswerExact = true
	THABJBTrivia.CanAnswerMulti = false
	category = ""

	local url = "https://numbersapi.p.mashape.com/random/trivia?fragment=true&json=true&max=500&mashape-key=9wanCl0NINmshoeqeu8DRAuau3h0p1qGtv2jsnoI2MGedj3Eju"
    http.Fetch(url,
      function(body, len, headers, code)
          jtable = util.JSONToTable(body)
		  local idx_corranswer =  math.random( 1, 4 )
		  local answers = {}

		  for i=1,4,1 do 
			offset = i - idx_corranswer
			answers[i] = jtable.number + offset
		  end
		  
		            
		  SendChatMsg("What is ".. jtable.text)
		  SendChatMsg("1] ".. answers[1])
		  SendChatMsg("2] ".. answers[2])
		  SendChatMsg("3] ".. answers[3])
		  SendChatMsg("4] ".. answers[4])
		  
		  THABJBTrivia.CorrectAnswer = tostring(idx_corranswer)
		  THABJBTrivia.Active = true
		  timer.Create( "THABJBTriviaTimer", THABJBTrivia.Timeout, 1, HandleJBTriviaTimer )

		  
      end,
      function( error )
          print("ERROR with fetching!")
      end
    );
end  



function THABJBTrivia:AskJeapordyTrivia1()

	THABJBTrivia.Type = "answer"
	THABJBTrivia.Timeout = 20
	THABJBTrivia.ImmediateWin = true
	THABJBTrivia.AnswerExact = false
	THABJBTrivia.CanAnswerMulti = true
	
	local url = "http://jservice.io/api/random"
    http.Fetch(url,
      function(body, len, headers, code)
          jtable = util.JSONToTable(body)
          
		  SendChatMsg("Your category: " .. jtable[1].category.title)
		  SendChatMsg(jtable[1].question)
		  THABJBTrivia.CorrectAnswer = tostring(jtable[1].answer)
		  THABJBTrivia.Active = true
		  timer.Create( "THABJBTriviaTimer", THABJBTrivia.Timeout, 1, HandleJBTriviaTimer )

		  
      end,
      function( error )
          print("ERROR with fetching!")
      end
    );
end  


function SendChatMsg(msg)
	--for k, ply in pairs( player.GetAll() ) do
	--	ply:ChatPrint( msg )
	--end
	net.Start("THAB.LR.Trivia.SendQuestion");
	net.WriteString(msg);
	net.Broadcast();
end


function HandleJBTriviaTimer()
	if (THABJBTrivia.Active == true) then
		SendChatMsg("The trivia round has ended without a winner. The correct answer was: ".. THABJBTrivia.CorrectAnswer)
		THABJBTrivia:SendAQuestion()
	end
end


function THABJBTrivia:EndTrivia()
	THABJBTrivia.Active = false
end

end