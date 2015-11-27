import Foundation

func readFile(filename: String) -> NSData? {
  if let path = NSBundle(forClass: MeServiceTests.self).pathForResource(filename, ofType: "json") {
    do {
      let jsonData = try NSData(contentsOfFile: path, options:[.DataReadingMappedIfSafe])
      return jsonData
    } catch {
      print("Error while reading file: \(error)")
    }
  }
  
  return nil
}
