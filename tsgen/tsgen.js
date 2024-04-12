import ts from 'typescript';
import * as fs from 'fs';
const fileName = "test/types.ts";
const sourceFile = ts.createSourceFile(fileName, fs.readFileSync(fileName).toString(), ts.ScriptTarget.ES2015, 
/*setParentNodes */ true);
// ts.forEachChild(sourceFile, (node => console.log(node)))
let root = sourceFile.statements[0];
const pretty = (node) => {
    const copy = { ...node };
    delete copy.parent;
    console.log(copy);
};
const convertTypes = (typ) => {
    if (typ === "number")
        return "float";
    return typ;
};
const compile = (node, file) => {
    if (ts.isInterfaceDeclaration(node)) {
        let properties = [];
        let other = [];
        node.members.forEach(it => {
            if (ts.isPropertySignature(it)) {
                properties.push(it);
            }
            else {
                other.push(it);
            }
        });
        return `module ${node.name.text} {\ntype t = {\n${properties.map(it => compile(it, file)).join(",\n")}\n}\n${other.map(it => compile(it, file)).join(",\n")}\n}`;
    }
    if (ts.isPropertySignature(node)) {
        let name;
        if (ts.isIdentifier(node.name)) {
            name = node.name.text;
        }
        let type = convertTypes(node.type.getText(file));
        return `mutable ${name}: ${type}`;
    }
    if (ts.isMethodSignature(node)) {
        pretty(node);
        console.log(node.getText(file));
        let name = '';
        if (ts.isIdentifier(node.name)) {
            name = node.name.text;
        }
        const args = node.parameters.map(it => convertTypes(it.type.getText(file)));
        return `@send external ${name}: (t, ${args}) => ${convertTypes(node.type.getText(file))} = "${name}"`;
    }
    console.log(node.kind);
};
console.log(compile(root, sourceFile));
