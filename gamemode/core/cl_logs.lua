-- ####################################################################################
-- ##                                                                                ##
-- ##                                                                                ##
-- ##     CASUAL BANANAS CONFIDENTIAL                                                ##
-- ##                                                                                ##
-- ##     __________________________                                                 ##
-- ##                                                                                ##
-- ##                                                                                ##
-- ##     Copyright 2014 (c) Casual Bananas                                          ##
-- ##     All Rights Reserved.                                                       ##
-- ##                                                                                ##
-- ##     NOTICE:  All information contained herein is, and remains                  ##
-- ##     the property of Casual Bananas. The intellectual and technical             ##
-- ##     concepts contained herein are proprietary to Casual Bananas and may be     ##
-- ##     covered by U.S. and Foreign Patents, patents in process, and are           ##
-- ##     protected by trade secret or copyright law.                                ##
-- ##     Dissemination of this information or reproduction of this material         ##
-- ##     is strictly forbidden unless prior written permission is obtained          ##
-- ##     from Casual Bananas                                                        ##
-- ##                                                                                ##
-- ##     _________________________                                                  ##
-- ##                                                                                ##
-- ##                                                                                ##
-- ##     Casual Bananas is registered with the "Kamer van Koophandel" (Dutch        ##
-- ##     chamber of commerce) in The Netherlands.                                   ##
-- ##                                                                                ##
-- ##     Company (KVK) number     : 59449837                                        ##
-- ##     Email                    : info@casualbananas.com                          ##
-- ##                                                                                ##
-- ##                                                                                ##
-- ####################################################################################


net.Receive("JB.GetLogs",function()
	local DamageLog = net.ReadTable();
	local printLog=tobool(net.ReadBit());

	if printLog then
		MsgC(JB.Color.white,"\n\n-- Damage Logs\n");
		for k,v in pairs(DamageLog) do
			MsgC(JB.Color.white,"["..v.time.."]["..v.kind.."] ");

			local clr=JB.Color.white;
			for k,v in pairs(v.message)do
				if type(v)=="table" and v.r and v.g and v.b then
					clr=v;
				elseif type(v)=="string" then
					MsgC(clr,v);
				end
			end
			MsgC(clr,"\n");
		end
	end

	JB.ThisRound.Logs = DamageLog;
end)