using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

public abstract class Enemy : IHealth, ILifecycle, IMovement
{
    // Health Attributes ---------------------
    public int Health { get; set; }
    public int MaxHealth { get; set; }


    public int Damage { get; set; }
    public int Armor { get; set; }
    public int MaxArmor { get; set; }
    public float Speed { get; set; }
    public float RunSpeed { get; set; }
    public float JumpVelocity { get; set; }

    // Entity Actions ---------------------
    public void TakeDamage(int damage)
    {
        if (Armor > 0)
        {
            Armor -= damage;
            if (Armor < 0)
            {
                Health += Armor;
                Armor = 0;
            }
        }
        else
        {
            Health -= damage;

            if (Health <= 0)
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

}