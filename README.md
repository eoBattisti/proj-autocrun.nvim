# autocrun.nvim
<div align="center">
<pre>
  ___  __ __ ______   ___     ___ ____  __ __ __  __
 // \\ || || | || |  // \\   //   || \\ || || ||\ ||
 ||=|| || ||   ||   ((   )) ((    ||_// || || ||\\||
 || || \\_//   ||    \\_//   \\__ || \\ \\_// || \||
 
--------------------------------------------------------------
A simple neovim plugin to compile and display the output of C code after save.
</pre>
</div>


### Motive
I'm writing this plugin as my first ever neovim plugin. I did to increase my knowledge about neovim and lua as weel, 
always trying to dig deeper into vim/nvim and learn new things about the editor.

<p style="color: red"><strong>NOTE: This plugin is still in development, it is not complete</strong></p>


### Instalation
---
- using [lazy.nvim](https://github.com/folke/lazy.nvim)
```lua
{
    "eoBattistti/autocrun.nvim",
    opts = <your_opts>
}
```


### To be implemented
---

- [ ] Add support for multiple languages
- [ ] Add more options to the plugin
- [ ] Split up the code into proper modules
- [ ] Add validations to commands being executed
- [ ] Add tests
- [ ] Close the message window properly


### How to contribute
---

Feel free to [open an issue](https://github.com/eoBattistti/autocrun.nvim/issues) or send a PR to [this repo](https://github.com/eoBattistti/autocrun.nvim/pulls).
Or just [fork this repo](https://github.com/eoBattistti/autocrun.nvim) and make your own plugin.
