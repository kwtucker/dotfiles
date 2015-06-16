#Dotfiles

##These are my settings, so if you are wanting any of my setting be sure to review all files. The ".git-prompt.sh" is tied to the ".bash_profile".

###Intstallation:
```
  cd ~
  
  git clone git@github.com:kwtucker/dotfiles.git
``` 

###Create symlinks

```
  ln -s ~/dotfiles/.vimrc ~/.vimrc
  
  ln -s ~/dotfiles/.bash_profile ~/.bash_profile
  
  ln -s ~/dotfiles/.git-completion.bash ~/.git-completion.bash
  
  ln -s ~/dotfiles/.git-prompt.sh ~/.git-prompt.sh
  
  ln -s ~/dotfiles/.vim ~/.vim
  
  ln -s ~/dotfiles/.gitconfig ~/.gitconfig
```

#####Set up [Vundle] (in the home directory):
```
   $ git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```
#####Then you must install your plugins.
In the home directory enter the following:
```
  vim 
  :PluginInstall
  :q 
```

####This is the prompt at the home directory.

![Image of Prompt](https://github.com/kwtucker/dotfiles/blob/master/bashPrompt/myPrompt.png)

####This is the prompt when you are in a git repo.

The status is colored based on the status. This can all be changed.

If you add changes it will show (master*). If you stage it for a commit it will show (master+). 

![Image of PromptGit](https://github.com/kwtucker/dotfiles/blob/master/bashPrompt/promptGit.png)

