#======================================================================================================================
# Command
#
#   Abstract class for any command we want to run in the Shell
#
#======================================================================================================================
package Shell::Command ;

use strict;

#======================================================================================================================
# §function     new
# §state        public
#----------------------------------------------------------------------------------------------------------------------
# §syntax       Command->new( $Shell, $Options )
#----------------------------------------------------------------------------------------------------------------------
# §description  Constructor
#----------------------------------------------------------------------------------------------------------------------
# §input        $Shell | The shell which creates and executes this command | object
# §input        $Options | Optionally a command could be build with some specific arguments | unknown
#----------------------------------------------------------------------------------------------------------------------
# §return       $Object | The new object instance | Object
#======================================================================================================================
sub new {
    my $Class = shift;

    my ( $Shell, $Options ) = @_ ;
    
    my $hAttributes = {
        'Shell'     => $Shell,
        'Options'   => $Options,
    };

    return bless( $hAttributes, $Class );
}

#======================================================================================================================
# §function     getName
# §state        public
#----------------------------------------------------------------------------------------------------------------------
# §syntax       $CommandName = $Command->getName() ;
#----------------------------------------------------------------------------------------------------------------------
# §description  Returns the name of the command
#----------------------------------------------------------------------------------------------------------------------
# §return       $Name | the command name | string
#======================================================================================================================
sub getName {
    my $self = shift;

    return 'cmd' ;
}

#======================================================================================================================
# §function     getAlias
# §state        public
#----------------------------------------------------------------------------------------------------------------------
# §syntax       $CommandAlias = $Command->getAlias() ;
#----------------------------------------------------------------------------------------------------------------------
# §description  Returns an array with all the alias for this command
#----------------------------------------------------------------------------------------------------------------------
# §return       $AliasList | All the alias for this command | array.ref
#======================================================================================================================
sub getAlias {
    my $self = shift;

    return [] ;
}

#======================================================================================================================
# §function     getArguments
# §state        public
#----------------------------------------------------------------------------------------------------------------------
# §syntax       $aArguments = $Command->getArguments() ;
#----------------------------------------------------------------------------------------------------------------------
# §description  Returns a hash with the arguments to use with the command. The hash will be use with the Getopt lib.
#----------------------------------------------------------------------------------------------------------------------
# §return       $hArgumens | Arguments specification for the command | hash.ref
#======================================================================================================================
sub getArguments {
    my $self = shift;

    return {} ;
}

#======================================================================================================================
# §function     getDescription
# §state        public
#----------------------------------------------------------------------------------------------------------------------
# §syntax       $aDescription = $Command->getDescription() ;
#----------------------------------------------------------------------------------------------------------------------
# §description  Returns a list of text lines with the short description for the command.
#----------------------------------------------------------------------------------------------------------------------
# §return       $aDescription | Description for the command | array.ref
#======================================================================================================================
sub getDescription {
    my $self = shift;

    return [ 'This is the abstract command class' ] ;
}

#======================================================================================================================
# §function     getHelp
# §state        public
#----------------------------------------------------------------------------------------------------------------------
# §syntax       $Help = $Command->getHelp()
#----------------------------------------------------------------------------------------------------------------------
# §description  Returns the detailed help of the command
#----------------------------------------------------------------------------------------------------------------------
# §return       $Help | The detailed command help | string
#======================================================================================================================
sub getHelp {
    my $self = shift;

    my $Help = "Description:\n" ;
    my $Description = $self->getDescription() ;
    foreach my $HelpLine ( @$Description ) {
        $Help .= "     $HelpLine\n" ;
    }

    return $Help ;
}

#======================================================================================================================
# §function     run
# §state        public
#----------------------------------------------------------------------------------------------------------------------
# §syntax       $Command->run( $hArguments ) 
#----------------------------------------------------------------------------------------------------------------------
# §description  Executes the command with the specified arguments
#----------------------------------------------------------------------------------------------------------------------
# §input        $hArguments | Arguments provided in the shell for this command | hash.ref
#======================================================================================================================
sub run {
    my $self = shift;

    my ( $Arguments) = @_ ;

    my $Console = $self->{'Shell'}->getConsole() ;
    
    $Console->debug( "Run Command (Abstract Class!)\n" ) ;
    $Console->output("Nothing to do !\n") ;

    return;
}

1;
