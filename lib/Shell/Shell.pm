#======================================================================================================================
# §package      Shell::Shell
#----------------------------------------------------------------------------------------------------------------------
# §description  TODO
#======================================================================================================================
package Shell::Shell;

use strict ;

use Shell::Console ;
use Shell::CommandLoader ;

use Getopt::Long qw ( 
    GetOptionsFromString 
) ;

my $BasicCommandsPath = 'Shell/Command' ;

my $aBasicCommandsList = [
    "$BasicCommandsPath/Alias",
    "$BasicCommandsPath/Clear",
    "$BasicCommandsPath/Config",
    "$BasicCommandsPath/Quit",
    "$BasicCommandsPath/Help"
] ;

#======================================================================================================================
# §function     new
# §state        public
#----------------------------------------------------------------------------------------------------------------------
# §syntax       my $Shell = Shell::Shell->new( $hOptions ) ;
#----------------------------------------------------------------------------------------------------------------------
# §description  Shell constructor
#----------------------------------------------------------------------------------------------------------------------
# §input        $hOptions | Construction options | hash.ref
#----------------------------------------------------------------------------------------------------------------------
# §return       $Shell | New object instance | object
#======================================================================================================================
sub new {
    my $class = shift;

    my $hOptions = $_[0] // {} ;

    my $hAttributes = {
        'Options'       => $hOptions,
        'Exit'          => 0,
        'Title'         => $hOptions->{'Title'} // 'Simple shell v1',
        'HelpTxt'       => 'Type \'help\' or \'?\' for help',
        'Debug'         => $hOptions->{'Debug'} // 0,
        'Prompt'        => $hOptions->{'Prompt'} // '> ',
        'Console'       => Shell::Console->new({ 'Pager' => $hOptions->{'Pager'} }) 
    } ;
    
    my $self = bless( $hAttributes, $class );
    
    $self->_initCommands() ;
    
    return $self ;
}

#======================================================================================================================
# §function     _initCommands
# §state        private
#----------------------------------------------------------------------------------------------------------------------
# §syntax       $Shell->_initCommands()
#----------------------------------------------------------------------------------------------------------------------
# §description  TODO
#======================================================================================================================
sub _initCommands {
    my $self = shift;

    my $aCommandsList = [] ;
    $self->{'CommandsList'} = $aCommandsList ;
    
    my $CommandLoader = Shell::CommandLoader->new( $self ) ;
    $self->_loadCommands( $CommandLoader, $aBasicCommandsList ) ;
    $self->_loadCommands( $CommandLoader, $self->{'Options'}->{'Commands'} ) ;
    
    my $aCommandsNames = [] ;
    my $hCommandsHash = {} ;

    foreach my $Command ( @$aCommandsList ) {
        my $CommandName = lc ( $Command->getName() ) ;
        my $aCommandAlias = $Command->getAlias() ;
        $hCommandsHash->{$CommandName} = $Command ;
        push( @$aCommandsNames, $CommandName ) ;
        if ( defined $aCommandAlias ) {
            foreach my $Alias ( @$aCommandAlias ) {
                $hCommandsHash->{lc( $Alias )} = $Command ;
            }
        }
    }

    $self->{'CommandsHash'} = $hCommandsHash ;
    $self->{'CommandsNames'} = [ sort @$aCommandsNames ] ;
    
    return ;
}

#======================================================================================================================
# §function     _loadCommands
# §state        private
#----------------------------------------------------------------------------------------------------------------------
# §syntax       $Shell->_loadCommands( $CommandsList, $CommandLoader, $aCommandsPathList )
#----------------------------------------------------------------------------------------------------------------------
# §description  TODO
#======================================================================================================================
sub _loadCommands {
    my $self = shift;

    my ( $CommandLoader, $aCommandsPathList ) = @_ ;

    my $aCommandsList = $self->{'CommandsList'} ;
    if ( defined $aCommandsPathList ) {
        foreach my $CommandPath ( @$aCommandsPathList ) {
            my $Command = $CommandLoader->loadCommand( $CommandPath ) ;
            if ( defined $Command ) {
                push( 
                    @$aCommandsList,
                    $Command 
                ) ;
            }
        }
    }

    return ;
}

#======================================================================================================================
# §function     getConsole
# §state        public
#----------------------------------------------------------------------------------------------------------------------
# §syntax       $Shell->getConsole()
#----------------------------------------------------------------------------------------------------------------------
# §description  TODO
#----------------------------------------------------------------------------------------------------------------------
# §return       $Console | TODO | object
#======================================================================================================================
sub getConsole {
    my $self = shift;

    return $self->{'Console'} ;
}

#======================================================================================================================
# §function     getAllCommands
# §state        public
#----------------------------------------------------------------------------------------------------------------------
# §syntax       $Shell->getAllCommands()
#----------------------------------------------------------------------------------------------------------------------
# §description  TODO
#----------------------------------------------------------------------------------------------------------------------
# §return       $CommandsList | TODO | array.object
#======================================================================================================================
sub getAllCommands {
    my $self = shift;

    return $self->{'CommandsList'} ;
}

#======================================================================================================================
# §function     getCommand
# §state        public
#----------------------------------------------------------------------------------------------------------------------
# §syntax       $Shell->getCommand( $CommandName )
#----------------------------------------------------------------------------------------------------------------------
# §description  TODO
#----------------------------------------------------------------------------------------------------------------------
# §input        $CommandName | TODO | string
#----------------------------------------------------------------------------------------------------------------------
# §return       $Command | TODO | object
#======================================================================================================================
sub getCommand {
    my $self = shift;

    my ( $CommandName ) = @_ ;

    return $self->{'CommandsHash'}->{$CommandName} ;
}

#======================================================================================================================
# §function     getCommandNames
# §state        public
#----------------------------------------------------------------------------------------------------------------------
# §syntax       $Shell->getCommandNames()
#----------------------------------------------------------------------------------------------------------------------
# §description  TODO
#----------------------------------------------------------------------------------------------------------------------
# §return       $CommandNamesList | TODO | array.string
#======================================================================================================================
sub getCommandNames {
    my $self = shift;

    return $self->{'CommandsNames'} ;
}


#======================================================================================================================
# §function     printHeader
# §state        public
#----------------------------------------------------------------------------------------------------------------------
# §syntax       $Shell->printHeader()
#----------------------------------------------------------------------------------------------------------------------
# §description  TODO
#======================================================================================================================
sub printHeader {
    my $self = shift;

    $self->getConsole()->output(
        "\n%s\n%s%s\n",
        $self->{'Title'},
        $self->getHeaderText(),
        $self->getHelpText()
    ) ;

    return;
}

#======================================================================================================================
# §function     getHeaderText
# §state        protected
#----------------------------------------------------------------------------------------------------------------------
# §syntax       $Shell->getHeaderText()
#----------------------------------------------------------------------------------------------------------------------
# §description  TODO
#----------------------------------------------------------------------------------------------------------------------
# §return       Header | TODO | string
#======================================================================================================================
sub getHeaderText {
    my $self = shift;

    return '';
}

#======================================================================================================================
# §function     getHelpText
# §state        protected
#----------------------------------------------------------------------------------------------------------------------
# §syntax       $Shell->getHelpText()
#----------------------------------------------------------------------------------------------------------------------
# §description  TODO
#----------------------------------------------------------------------------------------------------------------------
# §return       $HelpText | TODO | string
#======================================================================================================================
sub getHelpText {
    my $self = shift;

    return "Type 'help' or '?' for help\n" ;
}

#======================================================================================================================
# §function     run
# §state        public
#----------------------------------------------------------------------------------------------------------------------
# §syntax       $Shell->run()
#----------------------------------------------------------------------------------------------------------------------
# §description  TODO
#======================================================================================================================
sub run {
    my $self = shift;

    my $Console = $self->getConsole() ;
    
    $self->{'Exit'} = 0 ;
    while ( not $self->{'Exit'} ) {
        my $UserInput = $Console->prompt( "%s", $self->{'Prompt'} ) ;
        $UserInput =~ m/^\s*(\S*)\s*(.*)/ ;
        my $CommandName = $1 ;
        my $CommandArgs = $2 ;
        
        $Console->resetPager() ;
        $self->_runCommand( $CommandName, $CommandArgs ) ;
    }

    return;
}

#======================================================================================================================
# §function     _runCommand
# §state        private
#----------------------------------------------------------------------------------------------------------------------
# §syntax       $Shell->_runCommand( $CommandName, $CommandArgs )
#----------------------------------------------------------------------------------------------------------------------
# §description  TODO
#----------------------------------------------------------------------------------------------------------------------
# §input        $CommandName | TODO | string
# §input        $CommandArgs | TODO | string
#======================================================================================================================
sub _runCommand {
    my $self = shift;

    my ( $CommandName, $CommandArgs ) = @_ ;

    if ( length( $CommandName ) ) {
        my $Console = $self->getConsole() ;
        my $CommandKey = lc( $CommandName ) ;
        if ( defined $self->{'CommandsHash'}->{$CommandKey} ) {
            my $Command = $self->{'CommandsHash'}->{$CommandKey} ;
            my $hArguments = $self->_parseArguments( $Command, $CommandArgs ) ;
            eval {
                $Command->run( $hArguments ) ;
            };
            if ( $@ ) {
                $self->error( $@ ) ;
            }
        } else {
            $Console->output(
                "ERROR: Unknown command '%s'.\n%s\n",
                $CommandName,
                $self->{'HelpTxt'}
            ) ;
        }
        $Console->output( "\n" ) ;
    }
    
    return;
}

#======================================================================================================================
# §function     _parseArguments
# §state        private
#----------------------------------------------------------------------------------------------------------------------
# §syntax       $Shell->_parseArguments( $Command, $CommandArgs )
#----------------------------------------------------------------------------------------------------------------------
# §description  TODO
#----------------------------------------------------------------------------------------------------------------------
# §input        $Command | TODO | string
# §input        $CommandArgs | TODO | string
#----------------------------------------------------------------------------------------------------------------------
# §return       $hArguments | TODO | hash.ref
#======================================================================================================================
sub _parseArguments {
    my $self = shift;

    my ( $Command, $CommandArgs ) = @_ ;

    my $hArguments = { '@' => [] }  ;
    my @OptsList = ( $CommandArgs ) ;
    my $CmdOpts = $Command->getArguments() ;

    foreach my $OptName ( keys %$CmdOpts ) {
        my $OptItem = $CmdOpts->{$OptName} ;
        $hArguments->{$OptName} = $OptItem->[1] ;
        push (@OptsList , $OptItem->[0] => \$hArguments->{$OptName} );
    }

    my ( $ret, $args ) = GetOptionsFromString( @OptsList ) ;

    $hArguments->{'@'} = $args ;

    return $hArguments ;
}


#======================================================================================================================
# §function     exit
# §state        public
#----------------------------------------------------------------------------------------------------------------------
# §syntax       $Shell->exit( $ShowByeText )
#----------------------------------------------------------------------------------------------------------------------
# §description  TODO
#----------------------------------------------------------------------------------------------------------------------
# §input        $ShowByeText | TODO | boolean
#======================================================================================================================
sub exit {
    my $self = shift;

    my ( $ShowByeText ) = @_ ;
    
    if ( $ShowByeText ) {
        $self->getConsole()->output( "Exit shell. Bye !\n\n" ) ;
    }

    $self->{'Exit'} = 1 ;

    return ;
}

#======================================================================================================================
# §function     error
# §state        public
#----------------------------------------------------------------------------------------------------------------------
# §syntax       $Shell->error( $@ )
#----------------------------------------------------------------------------------------------------------------------
# §description  TODO
#----------------------------------------------------------------------------------------------------------------------
# §input        $ShowByeText | TODO | boolean
#======================================================================================================================
sub error {
    my $self = shift;

    $self->getConsole()->error( @_ ) ;

    return ;
}

1;