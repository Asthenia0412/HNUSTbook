class Grammer:
    def __init__(self, productions, start_symbol):
        self.productions = productions  # 产生式列表，如 [('E', ['E', '+', 'T']), ('E', ['T']), ...]
        self.start_symbol = start_symbol  # 开始符号
        self.non_terminals = set(p[0] for p in productions)  # 产生式列表中的0索引也就是箭头的左侧 是非终结符，例如A B C 右侧是终结符 a b c
        self.terminals = self._compute_terminals()



    def _compute_terminals(self):
        # 这个方法用于计算终结符
        terminals = set()
        for lhs, rhs in self.productions:
            for symbol in rhs:
                if symbol not in self.non_terminals and symbol!= 'ε':
                    terminals.add(symbol)
        return terminals

    def get_productions_for(self,non_terminal):
        return [p for p in self.productions if p[0]==non_terminal]