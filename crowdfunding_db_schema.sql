CREATE TABLE "campaign" (
    "cf_id" int   NOT NULL,
    "contact_id" int   NOT NULL,
    "company_name" varchar(100)   NOT NULL,
    "description" text   NOT NULL,
    "goal" numeric(10,2)   NOT NULL,
    "pledged" numeric(10,2)   NOT NULL,
    "outcome" varchar(50)   NOT NULL,
    "backers_count" int   NOT NULL,
    "country" varchar(10)   NOT NULL,
    "currency" varchar(10)   NOT NULL,
    "launch_date" date   NOT NULL,
    "end_date" date   NOT NULL,
    "category_id" varchar(10)   NOT NULL,
    "subcategory_id" varchar(10)   NOT NULL,
    CONSTRAINT "pk_campaign" PRIMARY KEY (
        "cf_id"
     )
);

CREATE TABLE "category" (
    "category_id" varchar(10)   NOT NULL,
    "category_name" varchar(50)   NOT NULL,
    CONSTRAINT "pk_category" PRIMARY KEY (
        "category_id"
     )
);

CREATE TABLE "subcategory" (
    "subcategory_id" varchar(10)   NOT NULL,
    "subcategory_name" varchar(50)   NOT NULL,
    CONSTRAINT "pk_subcategory" PRIMARY KEY (
        "subcategory_id"
     )
);

CREATE TABLE "contacts" (
    "contact_id" int   NOT NULL,
    "first_name" varchar(50)   NOT NULL,
    "last_name" varchar(50)   NOT NULL,
    "email" varchar(100)   NOT NULL,
    CONSTRAINT "pk_contacts" PRIMARY KEY (
        "contact_id"
     )
);

ALTER TABLE "campaign" ADD CONSTRAINT "fk_campaign_contact_id" FOREIGN KEY("contact_id")
REFERENCES "contacts" ("contact_id");

ALTER TABLE "campaign" ADD CONSTRAINT "fk_campaign_category_id" FOREIGN KEY("category_id")
REFERENCES "category" ("category_id");

SELECT * FROM campaign

ALTER TABLE "campaign" ADD CONSTRAINT "fk_campaign_subcategory_id" FOREIGN KEY("subcategory_id")
REFERENCES "subcategory" ("subcategory_id");


CREATE TABLE "backers" (
    "backer_id" varchar(10)   NOT NULL,
    "cf_id" int NOT NULL,
	"first_name" varchar(20) NOT NULL,
	"last_name" varchar(20) NOT NULL,
	"email" varchar (100) NOT NULL,
	CONSTRAINT "pk_backers" PRIMARY KEY (
		 "backer_id"
	)
 );
 SELECT * FROM backers
 
ALTER TABLE "backers" ADD CONSTRAINT "fk_backers_cf_id" FOREIGN KEY("cf_id")
REFERENCES "campaign" ("cf_id");

-- Create a backer count table
SELECT COUNT(b.backer_id), b.cf_id
INTO backer_count
FROM backers as b
JOIN campaign as c
ON (b.cf_id = c.cf_id)
WHERE (c.outcome = 'live')
GROUP BY b.cf_id
ORDER BY COUNT (b.backer_id) DESC;

SELECT * FROM backer_count

-- Create a email_contacts_remaining_goal_amount table 
SELECT ca.first_name, ca.last_name, ca.email, (c.goal - c.pledged) as remaining_goal_amount
INTO email_contacts_remaining_goal_amount
FROM contacts as ca
JOIN campaign as c
ON (ca.contact_id = c.contact_id)
WHERE (c.outcome = 'live')
ORDER BY remaining_goal_amount DESC;
SELECT * FROM email_contacts_remaining_goal_amount


-- create a table email_backers_goal_amount
SELECT ca.email, ca.first_name, ca.last_name, 
c.cf_id, 
c.company_name,
c.description,
c.end_date,
(c.goal - c.pledged) as left_of_goal
INTO email_backers_remaining_goal_amount
FROM contacts as ca
JOIN campaign as c
ON (ca.contact_id = c.contact_id)
ORDER BY email DESC;
SELECT * FROM email_backers_remaining_goal_amount

 
 
 
 
 
 