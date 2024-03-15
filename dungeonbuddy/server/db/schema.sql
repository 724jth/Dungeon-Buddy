DROP table if EXISTS creatures CASCADE;
DROP table if EXISTS initiative CASCADE;
DROP table if EXISTS players CASCADE;
-- clear and restart tables just in case of wierdness. 

CREATE TABLE creatures (
    id SERIAL PRIMARY KEY NOT NULL,
    name VARCHAR(50), --The name of the creature 
    size ENUM(tiny, small, medium, large, huge, gargantuan) , -- D&D size category
    armorclass INTEGER, -- Armor Class of the creature
    hitpoints INTEGER, -- HP of the creature
    initiative INTEGER, -- The statistic that determines what order the creatures act in, calculated by dexterity by default, but can be overritten when necessary
    strength INTEGER, -- how powerful the creature is, used to calculate strength modifier and saves
    dexterity INTEGER, -- how good the creatures reflexes are, used to caluclate dexterity modifier and saves
    constitution INTEGER, -- how healthy and sturdy the creature is, used to calculate constitution modifier and saves
    intelligence INTEGER, -- how much does the creature now, used to calculate intelligence modifier and saves
    wisdom INTEGER, -- how good the creature is at figuring things out, used to calculate wisdom modifier and saves 
    charisma INTEGER, -- how good the creature is at making others do things, used to calculate charisma modifier and saves
    senses VARCHAR(500), -- the different sense of the creature
    languages VARCHAR(500), -- what languages the creatures speaks
    walk INTEGER, -- walk speed of the creature 
    climb INTEGER, -- climb speed of a creature if they have it
    swim INTEGER, -- swim speed of the creature if they have it
    burrow INTEGER, -- burrow speed of the creature if they have it
    fly INTEGER, -- flying speed of the creature if they have it
    hover Boolean, -- represents the creatures ability to levitate, denoted on the creatures stat block
    casterlvl INTEGER, -- the total caster level of the creature, calculated when added to the table
    PC Boolean, -- is the afformentioned creature a player character
    cr float, -- the assigned combat rating of the creature, not applicable to player characters
);

CREATE TABLE players (
    id SERIAL PRIMARY KEY NOT NULL,
    creature_id INTEGER,
    name VARCHAR(50), --The name of the player character 
    
);

CREATE TABLE initiative (
    score INTEGER,
    creature_id INTEGER,
);

ALTER TABLE player
ADD CONSTRAINT "Creature_id"
FOREIGN KEY (creature_id) REFERENCES creatures(id);

ADD CONSTRAINT "Name"
FOREIGN KEY (name) REFERENCES creatures(name);

ALTER TABLE initiative
ADD CONSTRAINT "id_pair"
FOREIGN KEY (creature_id) REFERENCES creatures(id);