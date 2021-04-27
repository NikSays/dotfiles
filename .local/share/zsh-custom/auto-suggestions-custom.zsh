
#--------------------------------------------------------------------#
# Global Configuration Variables                                     #
#--------------------------------------------------------------------#

# Color to use when highlighting suggestion
# Uses format of `region_highlight`
# More info: http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Zle-Widgets
(( ! ${+ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE} )) &&
typeset -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

# Strategies to use to fetch a suggestion
# Will try each strategy in order until a suggestion is returned
typeset -ga ZSH_AUTOSUGGEST_STRATEGY
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

ZSH_AUTOSUGGEST_USE_ASYNC=1

# Widgets that accept the entire suggestion
typeset -ga ZSH_AUTOSUGGEST_ACCEPT_WIDGETS
ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(
	#forward-char
	end-of-line
	#vi-forward-char
	vi-end-of-line
	vi-add-eol
)

ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS+=(forward-char)
