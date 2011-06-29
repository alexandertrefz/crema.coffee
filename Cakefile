fs     = require "fs"
{exec} = require "child_process"

appFiles  = [
    "Core"
    "EventMachine"
    "Collection"
    "Module"
    "Model"
    "View"
    "ViewController"
]

option "-v", "--version [VERSION]", "Defines the Version."

task "build", "Build everything", (options) ->
    invoke("build:source")
    invoke("build:tests")
    console.log("Every build done.")


task "build:source", "Build crema.js from source", (options) ->
    
    options.version ?= "debug"
    appContents = []
    readFileCount = 0
    
    for file, index in appFiles then do (file, index) ->
        fs.readFile "src/#{file}.coffee", 'utf8', (err, fileContents) ->
            throw err if err
            
            appContents[index] = fileContents
            readFileCount++
            
            compile() if readFileCount is appFiles.length
        
    
            
    compile = ->
        filename = "crema-#{options.version}.coffee"
        path = "lib/#{filename}"
        fs.writeFile path, appContents.join('\n\n'), 'utf8', (err) ->
            throw err if err
            exec "coffee --bare --compile #{path}", (err, stdout, stderr) ->
                if err
                    console.log stdout + stderr
                    throw err
                    
                fs.unlink path, (err) ->
                    throw err if err
                    
                    console.log "#{filename} build done."
                
            
        
    



task "build:tests", "Build tests.js for crema.js", (options) ->
    exec "coffee --bare --compile tests/tests.coffee", (err, stdout, stderr) ->
        if err
            console.log stdout + stderr
            throw err
            
        console.log "tests.js build done."




