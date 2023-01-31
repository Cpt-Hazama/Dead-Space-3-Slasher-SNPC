if !CPTBase then return end
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.ModelTable = {"models/cpthazama/ds3/slasher.mdl"}
ENT.StartHealth = 125
-- ENT.CollisionBounds = Vector(18,18,50)

ENT.Faction = {"FACTION_NECROMORPH"}

ENT.MeleeAttackDistance = 50
ENT.MeleeAttackDamageDistance = 95
ENT.MeleeAttackType = DMG_SLASH
ENT.MeleeAttackDamage = 15
ENT.MeleeAttackHitTime = 0.35

ENT.RangeAttackDistance = 90

ENT.BloodEffect = {"blood_impact_red"}

ENT.tbl_Animations = {
	["Walk"] = {ACT_WALK},
	["Run"] = {ACT_RUN},
	["Attack"] = {ACT_MELEE_ATTACK1,ACT_MELEE_ATTACK2},
}

ENT.tbl_Sounds = {
	["FootStep"] = {
		"player/footsteps/concrete1.wav",
		"player/footsteps/concrete2.wav",
		"player/footsteps/concrete3.wav",
		"player/footsteps/concrete4.wav"
	},
	["Idle"] = {"cpthazama/ds3_slasher/slasher_1.wav","cpthazama/ds3_slasher/slasher_2.wav","cpthazama/ds3_slasher/slasher_3.wav"},
	["Attack"] = {"cpthazama/ds3_slasher/slasher_attack1.wav","cpthazama/ds3_slasher/slasher_attack2.wav"},
	["Pain"] = {"cpthazama/ds3_slasher/slasher_hurt1.wav"},
	["Death"] = {"cpthazama/ds3_slasher/slasher_4.wav","cpthazama/ds3_slasher/slasher_5.wav","cpthazama/ds3_slasher/slasher_6.wav"}
}

ENT.tbl_Capabilities = {CAP_OPEN_DOORS,CAP_USE,CAP_MOVE_CLIMB,CAP_MOVE_JUMP}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:SetInit()
	self:SetHullType(HULL_HUMAN)
	self:SetMovementType(MOVETYPE_STEP)
	self:SetSkin(math.random(0,1))
	self.IsAttacking = false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Possess_OnPossessed(possessor)
	possessor:ChatPrint("Possessor Controls:")
	possessor:ChatPrint("LMB - Attack")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInputAccepted(event)
	if event == "attack double" then
		self:DoDamage(self.MeleeAttackDamageDistance,self.MeleeAttackDamage *2,self.MeleeAttackType)
	elseif event == "attack single" then
		self:DoDamage(self.MeleeAttackDamageDistance,self.MeleeAttackDamage,self.MeleeAttackType)
	elseif event == "step" then
		self:PlayFootStepSound(true)
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:DoAttack()
	if self:CanPerformProcess() == false then return end
	if (!self.IsPossessed && IsValid(self:GetEnemy()) && !self:GetEnemy():Visible(self)) then return end
	self:CPT_StopCompletely()
	self:CPT_PlaySound("Attack",75)
	self:CPT_PlayAnimation("Attack",2)
	self.IsAttacking = true
	self:CPT_AttackFinish()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:HandleSchedules(enemy,dist,nearest,disp)
	if self.IsPossessed then return end
	if(disp == D_HT) then
		if nearest <= self.MeleeAttackDistance && self:CPT_FindInCone(enemy,self.MeleeAngle) then
			self:DoAttack()
		end
		if self:CanPerformProcess() then
			self:ChaseEnemy()
		end
	end
end