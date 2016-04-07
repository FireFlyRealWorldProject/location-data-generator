import std.json;
import std.stdio;
import std.file;
import std.string;
import std.random;
import std.conv;
import std.format;



bool isIn(string check, string str)
{
    writeln("checking if is in:");

    writeln(check);
    writeln(str);

    if (check == str)
    {   return true;    }

    return false;
}


void main(string[] args)
{


    //Open a file containing ilst of patiant IDs (else use for loop iterator)
    //Open file with Anthrax Symptoms
    //Open file with other symptoms
    //define json structure

    //Loop for how ever many patiants we asked for


    File JSON;
    File ids;
    File LocationPairs;

    string filename = args[4];

    if (args.length >= 4)       //Open the files
    {
        ids = File(args[1], "r");
        LocationPairs = File(args[2], "r");

    }
    else if (args.length == 2)
    {
        if (args[1] == "help")
        {
            writeln( "idsfile locationpairs [numberOfPatiants (0 to generate data for each ID)]");
            return;
        }

    }
    else
    {
        writeln("Not enough args");
        writeln( "idsfile locationpairs [numberOfPatiants (0 to generate data for each ID)]");
        return ;
    }

    string JSONStructureString = "{\"patiant_id\":\"\",\"locations\":[]}";       //Read in the JSON structure from file
    string JSONStructureFields[10];

    int lineCount = 1;


    JSONValue j = parseJSON(JSONStructureString);
    writefln("Doing %s IDs", args[3]);

    writeln("Using JSON structure: \n");
    writeln(j.toString());

    JSONValue patiants[];    //List of patiants

    patiants.length = to!int(args[3]);


    //Read in all the anthrax symptoms


    //XXX For now we have statically defined limits to how many symptoms there are - We could make this dynamic


    //TODO Put all this inside a function - Its horrible out here!

    JSONValue[] LocationPairsList;
    lineCount = 0;
    while(!LocationPairs.eof())
    {
        string line = strip (LocationPairs.readln());
        LocationPairsList ~= parseJSON(line);
        lineCount++;
    }

    writeln("Read in all the locaions");

    //How many symptoms does each patiant have maximum?

    int i = 0;
    while (!ids.eof())  //For every ID
    {
        if (i >= patiants.length)   //Check because EOF doesnt happen until i is already out of range
        { break; }

        patiants[i] = parseJSON(JSONStructureString); //New patiant
        patiants[i].object["patient_id"] = JSONValue(strip(ids.readln()));
        patiants[i].object["locations"] = JSONValue(LocationPairsList[uniform(0,LocationPairsList.length-1)]);   //Get random set of locations method

        i++;
    }


    foreach(int p, JSONValue patiant; patiants)
    {
        string patiantJSON = patiant.toPrettyString();
        append(filename, patiantJSON);
        append(filename, "\n");
//        writeln(patiantJSON);
    }

        






}
