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

option "-v", "--version", "Defines the Version."

task "build", "Build crema.js from Source", (options) ->
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
        path = "lib/crema.#{options.version}.coffee"
        fs.writeFile path, appContents.join('\n\n'), 'utf8', (err) ->
            throw err if err
            exec "coffee --bare --compile #{path}", (err, stdout, stderr) ->
                throw err if err
                console.log stdout + stderr
                fs.unlink path, (err) ->
                    throw err if err
                    console.log "Build Done."