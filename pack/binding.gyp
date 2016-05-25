{
	"targets": [{
		"target_name": "luanode",
		"product_extension": "node",
		"type": "shared_library",
		"include_dirs": [
			"cmodule/include"
		],
		"libraries": [
			"../cmodule/lib/liblua.a"
		],
		"sources": [
			"cmodule/luanode/values.cc",
			"cmodule/luanode/luastate.cc",
			"cmodule/luanode/luanode.cc"
		]
	}]
}
