later - schedule future events for todo.txt
==============

a simple addon providing for recurring and future todos in todo.txt

# Overview

*later* works as an action for the excellent [todo.txt](http://todotxt.com/). It builds on the idea of [recur](https://github.com/ginatrapani/todo.txt-cli/wiki/Todo.sh-Add-on-Directory#recur) add-on. I believe it improves on the ability to do something every X Friday by anchoring it on a date. In addition it does not require additional modules to be installed, since all functionality is handled by the core ruby installation, which is the only requirement.

Additionally you can easily move tasks from your current todo list to re-appear at a future time. Kind of like a snooze button.

# How it works

*later* should run via a scheduled task or, if so inclined, manually once a day. It will read the `later.txt` todo file and find items whose date fits the current date. Those items are then added to the normal `todo.txt` file.

Here is what the `later.txt` might look like.

    Mon take out garbage
    Mon,Tue,Sat make dinner
    1,14 do something on the 1st and 14th of month @personal
    Jul4,Dec25 Holiday tasks
    2014-03-03;Fri/2 every 2nd Friday
    2014-06-01..2014-10-01;Thu mow the lawn in the summer

Basically you can specify the following:

* a date in the todo.txt format: *2014-02-30*
* day of the week in the 3 letter format: *Mon*, *Tue*, *Wed*, *Thu*, *Fri*, *Sat*, *Sun*.
* a number indicating the day of the month. *1*, *12*,
* a month day such as *Nov11* (make sure to zero pad so *Nov03*, NOT *Nov3*)

You can also use a list of them separated by a comma and no spaces:

* Mon,Fri
* 1,15
* Jun01,Oct03

It's also possible to repear at intervals by adding */2* after one of the above. However if you want to use an interval like that you need to specify a start date and a *;*. For example:

    2014-04-01;Mon,Fri/2

means starting on *2014-04-01* every 2nd Monday and Friday.

Lastly the start date can also have an end date, which would stop repeating the task after the end date:

    2014-04-01..2014-05-01;Mon,Fri/2

Everything after the first space on a line becomes the todo item. By default *later* will not add items to your todo list if they they already exist. If you always want an item added simply add three exclamation points like this, which will be replaced by the date. That will make it unique

    Fri (A) !!! something todo every friday
    1,15 !!! always do something twice a month 

Note that you'll want to add the exclamation points after the priority to keep in line with the [Rule 2 of the todo.txt format](https://github.com/ginatrapani/todo.txt-cli/wiki/The-Todo.txt-Format#rule-2-a-tasks-creation-date-may-optionally-appear-directly-after-priority-and-a-space).

*later* will clean up after itself when it finds a simple dated task or one with an end date and remove those entries from the `later.txt` after adding them to your normal `todo.txt`



# Installation

* install *ruby* (I'm using version 1.9.3)
* download *later* to *todo.actions.d/* in your todo.txt directory
* create a `later.txt` (`todo.sh edit later` should do it)
* run later: `todo.sh later` and/or add it to your crontab

# Testing

There are quite a few unit tests based on [minitest](http://www.ruby-doc.org/stdlib-1.9.3/libdoc/minitest/unit/rdoc/MiniTest.html) for the date parsing. To run them simply call

    ruby test/test_laterdate.rb
