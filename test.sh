#!/bin/bash

DOSE_DOCS_PATH="/Volumes/Speakhard/DoseDevRoot/Dose/Other/docs/docs.json"
OUTPUT_DIR_PATH="/Volumes/Speakhard/DoseDevRoot/Dose/Other/scripts/swift-relationship-graph/output"

/Users/pho/repo/swift-relationship-graph/bin/swift-relationship-graph /Volumes/Speakhard/DoseDevRoot/Dose/Other/docs/docs.json dotGraphCode protocols,structs,classes > /Volumes/Speakhard/DoseDevRoot/Dose/Other/scripts/swift-relationship-graph/output/output_graph.dot
/Users/pho/repo/swift-relationship-graph/bin/swift-relationship-graph /Volumes/Speakhard/DoseDevRoot/Dose/Other/docs/docs.json dotTreeCode protocols,structs,classes > /Volumes/Speakhard/DoseDevRoot/Dose/Other/scripts/swift-relationship-graph/output/output_tree.dot 