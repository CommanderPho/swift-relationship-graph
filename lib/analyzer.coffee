_ = require 'lodash'

Constants = require './constants.coffee'

Key = Constants.Key
DeclarationType = Constants.DeclarationType

module.exports = (json) ->

  protocols = []
  structs = []
  classes = []
  extensions = []

  protocolsAndParents = {}
  structsAndParents = {}
  classesAndParents = {}

  parseEntry = (entry) ->
    for filename, subentry of entry
      parseSubentry subentry[Key.Substructure] if subentry[Key.Substructure]

  parseSubentry = (structures) ->

    KindHandlers =
      "#{DeclarationType.SwiftProtocol}": (s) -> protocols.push s
      "#{DeclarationType.SwiftStruct}": (s) -> structs.push s
      "#{DeclarationType.SwiftClass}": (s) -> classes.push s
      "#{DeclarationType.SwiftExtension}": (s) -> extensions.push s

      #"#{DeclarationType.ObjCProtocol}": (s) -> protocols.push s
      #"#{DeclarationType.ObjCStruct}": (s) -> structs.push s
      #"#{DeclarationType.ObjCClass}": (s) -> classes.push s

    for structure in structures
      parseSubentry structure[Key.Substructure] if structure[Key.Substructure]
      KindHandlers[structure[Key.Kind]]? structure

  if _.isArray json
    for entry in json
      parseEntry entry
  else
    parseEntry json

  parseEntity = (entity, type) ->

    TypeHandlers =
      "#{DeclarationType.SwiftProtocol}": (n, p) -> protocolsAndParents[n] = p
      "#{DeclarationType.SwiftStruct}": (n, p) -> structsAndParents[n] = p
      "#{DeclarationType.SwiftClass}": (n, p) -> classesAndParents[n] = p
      "#{DeclarationType.SwiftExtension}": (n, p) ->
        if classesAndParents[n]?
          classesAndParents[n] = _.concat classesAndParents[n], p
        if structsAndParents[n]?
          structsAndParents[n] = _.concat structsAndParents[n], p
        if protocolsAndParents[n]?
          protocolsAndParents[n] = _.concat protocolsAndParents[n], p
      #"#{DeclarationType.ObjCProtocol}": (n, p) -> protocolsAndParents[n] = p
      #"#{DeclarationType.ObjCStruct}": (n, p) -> structsAndParents[n] = p
      #"#{DeclarationType.ObjCClass}": (n, p) -> classesAndParents[n] = p

    if entity[Key.InheritedTypes]?

      parents = _.map entity[Key.InheritedTypes], (entry) ->

        name = _.trim entry[Key.Name]
        match = /^([^<]*)(?:<.*>)?$/gi.exec name
        name = _.nth match, 1

        return name

    else

      parents = []

    TypeHandlers[type]? entity[Key.Name], parents

  for protocol in protocols
    parseEntity protocol, DeclarationType.SwiftProtocol
    #parseEntity protocol, DeclarationType.ObjCProtocol

  for struct in structs
    parseEntity struct, DeclarationType.SwiftStruct
    #parseEntity struct, DeclarationType.ObjCStruct

  for klass in classes
    parseEntity klass, DeclarationType.SwiftClass
    #parseEntity klass, DeclarationType.ObjCClass

  for extension in extensions
    parseEntity extension, DeclarationType.SwiftExtension

  analysis =
    protocols: protocolsAndParents
    structs: structsAndParents
    classes: classesAndParents

  return analysis
