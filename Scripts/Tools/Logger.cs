﻿using Godot;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

public static class Logger
{
    public static void Log(string message) => GD.Print(message);
}
