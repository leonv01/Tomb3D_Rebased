using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

public abstract class Role : IHealth, IMovement, ILifecycle, IAttack
{
    // Entity Attributes ---------------------
    public int Health { get; set; }
    public int MaxHealth { get; set; }
    public int Damage { get; set; }
    public int Armor { get; set; }
    public int MaxArmor { get; set; }
    public float Speed { get; set; }
    public float RunSpeed { get; set; }
    public float JumpVelocity { get; set; }

    // Role Attributes ---------------------
    public string RoleName { get; set; }
    public string RoleDescription { get; set; }
    public int Level { get; set; }
    public int Experience { get; set; }
    public int ExperienceToNextLevel { get; set; }
    public int Mana { get; set; }
    public int MaxMana { get; set; }
    public int Energy { get; set; }
    public int MaxEnergy { get; set; }



    // Entity Actions ---------------------
    public void TakeDamage(int damage)
    {
        if(Armor > 0)
        {
            Armor -= damage;
            if(Armor < 0)
            {
                Health += Armor;
                Armor = 0;
            }
        }
        else
        {
            Health -= damage;

            if(Health <= 0)
            {
                Die();
            }
        }
    }
    public void Heal(int amount)
    {
        if(Health + amount > MaxHealth)
        {
            Health = MaxHealth;
        }
        else
        {
            Health += amount;
        }
    }
    public void Die()
    {

    }

    // Entity State ---------------------
    public void Spawn()
    {

    }
    public void Despawn()
    {

    }

    // Role Actions ---------------------
    public void LevelUp()
    {
        Level++;
        Experience = 0;
        // TODO: Implement a better leveling system
        ExperienceToNextLevel = Level * 100;
    }

    public void IncreaseExperience(int amount)
    {
        Experience += amount;
        if(Experience >= ExperienceToNextLevel)
        {
            LevelUp();
        }
    }

    public void IncreaseMana(int amount)
    {
        if(Mana + amount > MaxMana)
        {
            Mana = MaxMana;
        }
        else
        {
            Mana += amount;
        }
    }

    public void IncreaseEnergy(int amount)
    {
        if(Energy + amount > MaxEnergy)
        {
            Energy = MaxEnergy;
        }
        else
        {
            Energy += amount;
        }
    }

    public void DecreaseMana(int amount)
    {
        if(Mana - amount < 0)
        {
            Mana = 0;
        }
        else
        {
            Mana -= amount;
        }
    }

    public void DecreaseEnergy(int amount)
    {
        if(Energy - amount < 0)
        {
            Energy = 0;
        }
        else
        {
            Energy -= amount;
        }
    }

    public abstract void PrimaryAttack();
    public abstract void SecondaryAttack();
    public abstract void Ability1();
    public abstract void Ability2();
    public abstract void Ability3();

    public override string ToString()
    {
        return $"Health: {Health}\n";
    }
}