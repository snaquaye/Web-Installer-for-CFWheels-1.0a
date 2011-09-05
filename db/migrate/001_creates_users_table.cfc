<cfcomponent extends="plugins.dbmigrate.Migration" hint="creates users table">
  <cffunction name="up">
    <cfscript>
    t = createTable('users');
    t.string("username");
    t.string("password");
    t.string("email");
    t.string("firstName");
    t.string("lastName");
    t.string("admin");
    t.string("activationCode");
    t.timestamps("lastLogin");
    t.timestamps("createdAt");
    t.timestamps("updatedAt");
   
    t.create();
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
    dropTable('users');
    </cfscript>
  </cffunction>
</cfcomponent>
